//
//  YEnumConfig.h
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/4/15.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#ifndef YEnumConfig_h
#define YEnumConfig_h

@import UIKit;
@import AssetsLibrary;

#pragma mark - 

typedef enum : NSUInteger {
    
    YChoosePhotoSequenceTypeDefault = 0,    //默认是按照选择的顺序
    YChoosePhotoSequenceTypeDate            //按照图片在相册的顺序

} YChoosePhotoSequenceType;



#pragma mark -
//照片选择的Block回调
typedef void(^ImagesBlock)(NSArray <UIImage *> *);



#pragma mark - YPhotoManager
typedef void(^ALAssetGroupBlock)(NSArray <ALAssetsGroup *> * groups);
typedef void(^ALAssetPhotoBlock)(NSArray <ALAsset *> * photos);
typedef void(^ALAssetFailBlock)(NSString * error);


#pragma mark - YPhotoCollectionViewCell
typedef void(^YPhotoCollectionViewBlock)(void);


#endif /* YEnumConfig_h */
