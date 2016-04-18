//
//  YPhotoCollectionViewCell.m
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/3/30.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPhotoCollectionViewCell.h"


typedef enum : NSUInteger {
    
    CellChoosedTypeOff = 0, //默认为未选中
    CellChoosedTypeOn,      //选中状态
    
} CellChoosedType;


@interface YPhotoCollectionViewCell ()


/**
 *  自定义bundle的路径
 */
@property (nonatomic, copy)NSString * bundlePath;


/**
 *  正常的图片
 */
@property (nonatomic, strong) UIImage * normalImage;


/**
 *  选中的图片
 */
@property (nonatomic, strong) UIImage * chooseImage;


/**
 *  显示选中图的ImageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;


/**
 *  状态的ImageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;


/**
 *  当前状态
 */
@property (nonatomic, assign)CellChoosedType choosedType;

@end



@implementation YPhotoCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self loadCollectionViewCell];
    }
    
    return self;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadCollectionViewCell];
}


- (void)loadCollectionViewCell
{
    self.chooseImageView.image = self.normalImage;
}


-(void)didSelected
{
    //不再隐藏
    self.chooseImageView.image = self.chooseImage;
    
    //先缩放
    [UIView animateWithDuration:0.2 animations:^{
        
        self.chooseImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        
    } completion:^(BOOL finished) {
        
        //重新变回去
        [UIView animateWithDuration:0.2 animations:^{
           
            self.chooseImageView.transform = CGAffineTransformMakeScale(1, 1);
            
        }];
        
    }];
    
}


-(void)didDeSelected
{
    //隐藏
    self.chooseImageView.image = self.normalImage;
}


- (void)hiddenSelectdImage
{
    self.chooseImageView.hidden = true;
}


#pragma mark - Getter

-(UIImage *)normalImage
{
    return [UIImage imageWithContentsOfFile:[self.bundlePath stringByAppendingPathComponent:@"未选中.png"]];
}


-(UIImage *)chooseImage
{
    return [UIImage imageWithContentsOfFile:[self.bundlePath stringByAppendingPathComponent:@"选中.png"]];
}


-(NSString *)bundlePath
{
    //获取路径
    NSString * path = [[NSBundle mainBundle] pathForResource:@"YPhotoBundle" ofType:@"bundle"];
    
    return [path stringByAppendingPathComponent:@"Image"];
    
}



@end
