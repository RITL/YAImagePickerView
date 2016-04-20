//
//  YGroupTableViewCell.h
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/3/30.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGroupTableViewCell : UITableViewCell


/**
 *  显示略图的图像视图
 */
@property (strong, nonatomic) UIImageView *headImageView;


/**
 *  显示姓名标签
 */
@property (strong, nonatomic) UILabel *lblName;


/**
 *  显示图片的数量
 */
@property (strong, nonatomic) UILabel *lblNumber;




@end
