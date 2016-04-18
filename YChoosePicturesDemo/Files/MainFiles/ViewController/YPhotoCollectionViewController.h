//
//  YPhotoCollectionViewController.h
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/3/31.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YEnumConfig.h"




@interface YPhotoCollectionViewController : UICollectionViewController

/**
 *  返回图片的顺序
 */
@property (nonatomic, assign) YChoosePhotoSequenceType photoSequenceType;

/**
 *  Done按钮被点击进行的回调设置
 *
 *  @param images 返回选中的数组
 */
- (void)imageDidSelect:(void (^)(NSArray <UIImage *> *)) images;



@end
