//
//  YPhotoBrowseViewController.h
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/4/19.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YEnumConfig.h"

/**
 *  浏览高清图片的控制器
 */
@interface YPhotoBrowseViewController : UIViewController


/**
 *  当前看的资源对象
 */
@property (nonatomic, strong) ALAsset * currentAsset;


@end
