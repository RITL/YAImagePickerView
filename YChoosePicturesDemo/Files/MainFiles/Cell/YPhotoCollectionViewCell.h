//
//  YPhotoCollectionViewCell.h
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/3/30.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPhotoCollectionViewCell : UICollectionViewCell

/**
 *  展示照片的CollectionViewCell
 */
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;



/**
 *  隐藏选中图片
 */
- (void)hiddenSelectdImage;


/**
 *  已经被选中
 */
- (void)didSelected;


/**
 *  已经不被选中
 */
- (void)didDeSelected;




@end
