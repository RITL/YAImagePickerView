 //
//  YPhotoManager.m
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/3/30.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPhotoManager.h"


@interface YPhotoManager ()

@property (nonatomic, strong) ALAssetsLibrary * library;
@property (nonatomic, copy) ALAssetGroupBlock block;

@property (nonatomic, strong) NSMutableArray <ALAssetsGroup *> * groups;//存放所有照片组的数组对象
@property (nonatomic, strong) NSMutableArray <ALAsset *> * photos;//存放所有照片的数组对象

@end

@implementation YPhotoManager


-(instancetype)init
{
    if (self = [super init])
    {
        //实例化库对象
        self.library = [[ALAssetsLibrary alloc]init];
        
        //初始化数组
        self.groups = [NSMutableArray arrayWithCapacity:0];
        self.photos = [NSMutableArray arrayWithCapacity:0];

    }
    
    return self;
}


+(instancetype)shareInstance
{
    static YPhotoManager * photoManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoManager = [[YPhotoManager alloc]init];
    });
    
    return photoManager;
}



//-(void)myPhotosGroup:(ALAssetGroupBlock)groupBlock
//{
//    self.block = groupBlock;
//}
//
//-(void)reloadPhotosGroup:(ALAssetGroupBlock)groupBlock
//{
//    
//}





///**
// *  是否允许查看相册
// *
// *  @return true为允许
// */
//- (void)isAllowToPhoteAlbum
//{
//    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized)
//        return;
//    
//    else
//    {
//        //请求权限
//        
//    }
//    
//    return ;
//}


/**
 *  创建组名叫做title的相片组
 *
 *  @param title 组名
 */
- (void)createGroupWithTitle:(NSString *)title
{
    //开始创建
    [self.library addAssetsGroupAlbumWithName:title resultBlock:^(ALAssetsGroup *group) {
        
        NSLog(@"创建成功!");
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"error = %@",error.localizedDescription);
        
    }];
}




//ALAssetsGroupLibrary        //从iTunes 来的相册内容（如本身自带的向日葵照片）
//ALAssetsGroupAlbum          //设备自身产生或从iTunes同步来的照片，但是不包括照片流跟分享流中的照片。(例如从各个软件中保存下来的图片)
//ALAssetsGroupEvent          //相机接口事件产生的相册
//ALAssetsGroupFaces          //脸部相册（具体不清楚）
//ALAssetsGroupSavedPhotos    //"相册胶卷"里面的照片
//ALAssetsGroupPhotoStream    //照片流
//ALAssetsGroupAll            //除了ALAssetsGroupLibrary上面所的内容




#pragma mark - 读取相册的所有组

/**
 *  读取相册的所有组
 *
 *  @param groupBlock 获取组成功的回调
 *  @param failBlock  失败的回调
 */
- (void)readAllPhotoGroups:(ALAssetGroupBlock)groupBlock Fail:(ALAssetFailBlock)failBlock
{
   [self readAllPhotoGroups:groupBlock Fail:failBlock CameraRollHandel:^{}];
    
}


/**
 *  读取相册的所有组
 *
 *  @param groupBlock       获取组成功的回调
 *  @param failBlock        失败的回调
 *  @param cameraRollHandle 相机胶卷不为nil时候进行的回调
 */
-(void)readAllPhotoGroups:(ALAssetGroupBlock)groupBlock Fail:(ALAssetFailBlock)failBlock CameraRollHandel:(void (^)(void))cameraRollHandle
{
    //删除之前存的所有组
    [self.groups removeAllObjects];
    
    __block __weak typeof(self) copy_self = self;
    
    //开始遍历
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        //如果返回的组存在
        if (group)
        {
            //对group进行过滤,只要照片
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            //添加数据
            [copy_self.groups addObject:group];
            
            //进行顺序判断
            if([self containCameraRoll:group] == true)
            {
                //删除当前位置的数组
                [self.groups removeObjectAtIndex:self.groups.count - 1];
                [self.groups insertObject:group atIndex:0];
            }
            
            //回调数据
            groupBlock([NSArray arrayWithArray:copy_self.groups]);
            
            //进行序列后的回调
            if([self containCameraRoll:group] == true)
                cameraRollHandle();
            
        }
        
    } failureBlock:^(NSError *error) {
        
        //失败回调
        failBlock(error.localizedDescription);
    }];
}


/**
 *  判断是否包含相机胶卷
 *
 *  @param group ALAssetsGroup对象
 *
 *  @return true表示包含，false反之
 */
- (BOOL)containCameraRoll:(ALAssetsGroup *)group
{
    //如果是相机胶卷，放到第一位,这里只适配英文以及中文
    NSString * nameCN = NSLocalizedString([group valueForProperty:ALAssetsGroupPropertyName], @"");
    NSString * nameEN = NSLocalizedString([group valueForProperty:ALAssetsGroupPropertyName], @"");
    
    //对当前组数进行排序
    if ([nameCN isEqualToString:@"相机胶卷"]
        || [nameEN isEqualToString:@"Camera Roll"])
    {
        //修改变量
        return true;
    }
    
    return false;
}


#pragma mark - 打开相片组
-(void)openPhotosGroup:(ALAssetsGroup *)assetsGroup Success:(ALAssetPhotoBlock)successBlock Fail:(ALAssetFailBlock)failBlock
{
    //删除所有的照片对象
    [self.photos removeAllObjects];
    
    //避免强引用
    __block __weak typeof(self) copy_self = self;
    
    //获取当前组的url数据
    NSURL * url = [assetsGroup valueForProperty:ALAssetsGroupPropertyURL];
    
    //打开向前的组
    [self.library groupForURL:url resultBlock:^(ALAssetsGroup *group) {
        
        [copy_self photosInGroups:group Block:successBlock];
        
    } failureBlock:^(NSError *error) {
        
        //失败的回调
        failBlock(error.localizedDescription);
    }];
}



//获取所有的照片对象
- (void)photosInGroups:(ALAssetsGroup *)group Block:(ALAssetPhotoBlock)photoBlock
{
    
    //开始读取
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        //如果不为空或者媒体为图片
        if (result != nil && [[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
        {
            
            //添加数据
            [self.photos addObject:result];
            
            //数目达标后统一进行回调
            if (index == group.numberOfAssets - 1)
            {
                //回调
                photoBlock([NSArray arrayWithArray:self.photos]);
                
            }

        }
    }];
}



@end
