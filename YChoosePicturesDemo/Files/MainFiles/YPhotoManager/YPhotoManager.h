//
//  YPhotoManager.h
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/3/30.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YEnumConfig.h"


/**
 *  照片的管理者
 */
@interface YPhotoManager : NSObject



/**
 *  单例方法
 *
 *  @return YPhotoManager单例对象
 */
+ (instancetype)shareInstance;


/**
 *  读取相册的所有组
 *
 *  @param groupBlock 获取组成功的回调
 *  @param failBlock  失败的回调
 */
- (void)readAllPhotoGroups:(ALAssetGroupBlock)groupBlock Fail:(ALAssetFailBlock)failBlock;






/**
 *  读取相册的所有组
 *
 *  @param groupBlock       获取组成功的回调
 *  @param failBlock        失败的回调
 *  @param cameraRollHandle 相机胶卷不为nil时候进行的回调
 */
- (void)readAllPhotoGroups:(ALAssetGroupBlock)groupBlock Fail:(ALAssetFailBlock)failBlock CameraRollHandel:(void (^)(void)) cameraRollHandle;




/**
 *  打开相片组
 *
 *  @param assetsGroup  需要打开的相片组
 *  @param successBlock 成功的回调
 *  @param failBlock    失败的回调
 */
- (void)openPhotosGroup:(ALAssetsGroup *)assetsGroup Success:(ALAssetPhotoBlock)successBlock Fail:(ALAssetFailBlock)failBlock;




@end
