//
//  YGroupTableViewCell.m
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/3/30.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YGroupTableViewCell.h"

@implementation YGroupTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self loadGroupTableViewCell];
    }
    
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self loadGroupTableViewCell];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/**
 *  加载cell
 */
- (void)loadGroupTableViewCell
{
    [self loadAllViews];
    [self startAutoLayout];
}


/**
 *  加载所有的视图
 */
- (void)loadAllViews
{
    [self addSubview:self.headImageView];
    [self addSubview:self.lblName];
    [self addSubview:self.lblNumber];
}


#pragma mark - Getter


-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _headImageView;
}



-(UILabel *)lblName
{
    if (_lblName == nil)
    {
        _lblName = [[UILabel alloc]init];
        _lblName.translatesAutoresizingMaskIntoConstraints = false;
        _lblName.font = [UIFont systemFontOfSize:14];
    }
    return _lblName;
}



-(UILabel *)lblNumber
{
    if (_lblNumber == nil)
    {
        _lblNumber = [[UILabel alloc]init];
        _lblNumber.translatesAutoresizingMaskIntoConstraints = false;
        _lblNumber.font = [UIFont systemFontOfSize:12];
    }
    return _lblNumber;
}

#pragma mark - 

/**
 *  开始添加约束
 */
- (void)startAutoLayout
{
    [self layoutHeadImageView];
    [self layoutLblName];
    [self layoutLblNumber];
}



/**
 *  给图像设置约束
 */
- (void)layoutHeadImageView
{
    NSArray * hor1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_headImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headImageView)];
    
    NSArray * ver1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_headImageView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headImageView)];
    
    //设置比例约束
    NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:_headImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_headImageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    
    [self addConstraints:hor1];
    [self addConstraints:ver1];
    [self addConstraint:constraint];
}


/**
 *  给组名称设置约束
 */
- (void)layoutLblName
{
    NSArray * hor2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_headImageView]-20-[_lblName]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headImageView,_lblName)];
    
    NSArray * ver2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_lblName(21)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headImageView,_lblName)];
    
    [self addConstraints:hor2];
    [self addConstraints:ver2];
}

/**
 *  给相册数量添加约束
 */
- (void)layoutLblNumber
{
    
    NSArray * hor3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_headImageView]-20-[_lblNumber]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headImageView,_lblNumber)];
    
    NSArray * ver3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lblName]-0-[_lblNumber(15)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lblName,_lblNumber)];
    

    [self addConstraints:hor3];
    [self addConstraints:ver3];
}

@end
