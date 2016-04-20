//
//  YPhotoCollectionViewController.m
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/3/31.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPhotoCollectionViewController.h"
#import "YPhotoBrowseViewController.h"
#import "YPhotoCollectionViewCell.h"
#import "YPhotoManager.h"
@import AssetsLibrary;
@import ImageIO;

@interface YPhotoCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ALAssetsGroup * group;

@property (nonatomic, assign) CGFloat size;                                     //标准大小
@property (nonatomic, strong) NSMutableArray <UIImage *> * allImages;           //存放所有的图片对象
@property (nonatomic, strong) NSMutableArray <NSNumber *> * imagesSign;         //所有图片的标志位，为传出保证照片在相册的顺序
@property (nonatomic, strong) NSMutableArray <ALAsset *> * photos;              //存储ALAsset对象的数组
@property (nonatomic, strong) NSMutableArray <UIImage *> * choosedImages;       //存放选中的图片对象
@property (nonatomic, copy) ImagesBlock imagesBlock;                            //代码块属性

@end

@implementation YPhotoCollectionViewController

static NSString * const reuseIdentifier = @"YPhotoCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化存储的数组
    self.allImages = [NSMutableArray array];
    self.imagesSign = [NSMutableArray array];
    _choosedImages = [NSMutableArray array];

    //初始化数据,适配横屏
    CGFloat minLength = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    self.size = (minLength - 3) / 4.0f;
    
    //设置导航标题
    self.navigationItem.title = [self.group valueForProperty:ALAssetsGroupPropertyName];
    
    //右侧的确定按钮
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(choosedImage)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //设置collection
    self.collectionView.allowsMultipleSelection = true;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //注册cell
    [self.collectionView registerClass:[YPhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //开始加载图片信息
    [self loadPhotos];

}


/**
 *  加载所有的图片
 */
- (void)loadPhotos
{
    [[YPhotoManager shareInstance] openPhotosGroup:self.group Success:^(NSArray<ALAsset *> *photos) {
        
        self.photos = [NSMutableArray arrayWithArray:photos];

        //初始化存放图片的数组
        [self loadAllImages];
            
        //初始化标志位数组
        [self loadSignImages:self.photos.count];

        //刷新
        [self.collectionView reloadData];
        
        //滚动到最后一个的位置
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.photos.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:false];
        
        
    } Fail:^(NSString *error) {
        
        NSLog(@"error = %@",error);
        
    }];
}



//设置回调
- (void)imageDidSelect:(void (^)(NSArray <UIImage *> *)) images
{
    self.imagesBlock = images;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //初始化cell
    YPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //检测cell
    [self checkCellDidSelect:cell Number:self.imagesSign[indexPath.item]];
    
    //这里尽量不用thumbnail属性，因为太模糊了，可以用aspectRatioThumbnail比例缩略图代替
    cell.photoImageView.image = [UIImage imageWithCGImage:self.photos[indexPath.item].aspectRatioThumbnail];
    
    //初始化回调
    [cell choosedImageDidTap:^{
        
        [self switchPhotoHandle:^{
            //添加图片
            [_choosedImages addObject:self.allImages[indexPath.item]];
            [self.imagesSign replaceObjectAtIndex:indexPath.item withObject:[NSNumber numberWithBool:true]];
    
        } DateHandle:^{
            //修改标志位
            [self.imagesSign replaceObjectAtIndex:indexPath.item withObject:[NSNumber numberWithBool:true]];
        }];
    }];
    
    
    [cell disChoosedImageDidTap:^{
        
        [self switchPhotoHandle:^{
            //删除图片
            [_choosedImages removeObject:self.allImages[indexPath.item]];
            [self.imagesSign replaceObjectAtIndex:indexPath.item withObject:[NSNumber numberWithBool:false]];
    
        } DateHandle:^{
            //修改标志位
            [self.imagesSign replaceObjectAtIndex:indexPath.item withObject:[NSNumber numberWithBool:false]];
        }];
    }];
    
    return cell;
}


/**
 *  检测cell是否被点击过
 *
 *  @param cell   检测的cell对象
 *  @param number 标志位对象
 */
-(void)checkCellDidSelect:(YPhotoCollectionViewCell *)cell Number:(NSNumber *)number
{
    //说明没有被选
    if (number.boolValue == false)
    {
        [cell didDeSelected];
    }
    
    //说明被选
    else
    {
        [cell didSelected];
    }
}


#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //获取当前的资源对象
    ALAsset * asset = self.photos[indexPath.item];
    
    //创建浏览控制器
    YPhotoBrowseViewController * browerViewController = [[YPhotoBrowseViewController alloc] init];
    
    //设置初始值
    browerViewController.currentAsset = asset;
    
    //弹出
    [self.navigationController pushViewController:browerViewController animated:true];

}


#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.size, self.size);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}


#pragma mark - Block Action
/**
 *  完成选择照片
 */
- (void)choosedImage
{
    //进行回调
    self.imagesBlock([NSArray arrayWithArray:self.choosedImages]);
    
    //模态弹出
    [self.navigationController dismissViewControllerAnimated:true completion:^{}];
}

#pragma mark - Getter

//返回选中的图片数组
-(NSMutableArray <UIImage *> *)choosedImages
{

    if (self.photoSequenceType == YChoosePhotoSequenceTypeDate)
    {
        NSMutableArray <UIImage *> * images = [NSMutableArray array];

        for(NSInteger i = 0; i < self.imagesSign.count ; i++)
        {
            if (self.imagesSign[i].boolValue == true)
            {
                [images addObject:self.allImages[i]];
            }
        }

        //返回
        return [NSMutableArray arrayWithArray:images];
    }
    
    return _choosedImages;
}


/**
 *  初始化计数数组
 *
 *  @param count 个数
 */
- (void)loadSignImages:(NSInteger)count
{
    for (NSInteger i = 0; i < count; i++)
    {
        [self.imagesSign addObject:[NSNumber numberWithBool:false]];
    }
}


/**
 *  加载所有的图片对象
 */
- (void)loadAllImages
{
    //进行资源处理
    for (ALAsset * asset in self.photos)
    {
        //这里就不要用thumbnail属性了，太模糊
        [self.allImages addObject:[UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
        
    }
}


/**
 *  根据类型进行不同的操作
 *
 *  @param defaultHandle 默认按照选中顺序排列
 *  @param dateHandle    按照日期属性排列
 */
- (void)switchPhotoHandle:(void(^)(void))defaultHandle DateHandle:(void(^)(void))dateHandle
{
    switch (self.photoSequenceType) {
            
        //按照选中顺序排列
        case YChoosePhotoSequenceTypeDefault:
        {
            defaultHandle();
        }
        break;
           
        //按照日期顺序排列
        case YChoosePhotoSequenceTypeDate:
        {
            dateHandle();
        }
        break;
    }
}
@end
