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
@property (strong, nonatomic) UIButton *chooseImageView;


/**
 *  当前状态
 */
@property (nonatomic, assign)CellChoosedType choosedType;

@property (nonatomic, copy) YPhotoCollectionViewBlock didTapBlock; //选中执行的回调
@property (nonatomic, copy) YPhotoCollectionViewBlock disTapBlock; //撤销选中执行的回调

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
    [self loadAllViews];
    [self startAutoLayout];
}

/**
 *  加载所有的view
 */
- (void)loadAllViews
{
    [self addSubview:self.photoImageView];
    [self addSubview:self.chooseImageView];
}


#pragma mark - 设置回调
-(void)choosedImageDidTap:(YPhotoCollectionViewBlock)chooseTapBlockHandle
{
    _didTapBlock = chooseTapBlockHandle;
}

-(void)disChoosedImageDidTap:(YPhotoCollectionViewBlock)disChooseTapBlockHandle
{
    _disTapBlock = disChooseTapBlockHandle;
}



-(void)didSelected
{
    //修改状态
    self.choosedType = CellChoosedTypeOn;
    
    //变化
    [self.chooseImageView setImage:self.chooseImage forState:UIControlStateNormal];
}


-(void)didDeSelected
{
    //修改状态
    self.choosedType = CellChoosedTypeOff;
    
    //变化
    [self.chooseImageView setImage:self.normalImage forState:UIControlStateNormal];
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



//显示图片的视图
-(UIImageView *)photoImageView
{
    if (_photoImageView == nil)
    {
        _photoImageView = [[UIImageView alloc]init];
        _photoImageView.translatesAutoresizingMaskIntoConstraints = false;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.layer.masksToBounds = true;
    }
    
    return _photoImageView;
}


//显示选择按钮的视图
- (UIButton *)chooseImageView
{
    if (_chooseImageView == nil)
    {
        _chooseImageView = [self buttonCustom:@selector(chooseImageDidClick)];
        _chooseImageView.translatesAutoresizingMaskIntoConstraints = false;
        [_chooseImageView setImage:self.normalImage forState:UIControlStateNormal];
    }
    
    return _chooseImageView;
}


/**
 *  根据回调方法创建按钮对象
 *
 *  @param selector 回调执行的方法
 *
 *  @return 创建完毕的按钮对象
 */
- (UIButton *)buttonCustom:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = false;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


/**
 *  按钮点击执行的操作
 */
- (void)chooseImageDidClick
{
    //设置之后的操作
    switch (self.choosedType) {
            
            //选中
        case CellChoosedTypeOff:
            [self choosedImageHandle];
            break;
            
            //撤销
        case CellChoosedTypeOn:
            [self disChoosedImageHandle];
            break;
    }
}



//选中进行的回调
- (YPhotoCollectionViewBlock)didTapBlock
{
    if (_didTapBlock == nil)
    {
        //设置初值
        _didTapBlock = ^(){};
    }
    
    return _didTapBlock;
}

//撤销进行的回调
-(YPhotoCollectionViewBlock)disTapBlock
{
    if (_disTapBlock == nil)
    {
        //设置初值
        _disTapBlock = ^(){};
    }
    
    return _disTapBlock;
}


#pragma mark -
/**
 *  选中进行的操作
 */
- (void)choosedImageHandle
{
    [self.chooseImageView setImage:self.chooseImage forState:UIControlStateNormal];
    
    //先缩放
    [UIView animateWithDuration:0.2 animations:^{
        
        self.chooseImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        
    } completion:^(BOOL finished) {
        
        //重新变回去
        [UIView animateWithDuration:0.2 animations:^{
            
            self.chooseImageView.transform = CGAffineTransformMakeScale(1, 1);
            
        }];
        
    }];
    
    //执行回调
    self.didTapBlock();
    
    //变化状态
    self.choosedType = CellChoosedTypeOn;
}


/**
 *  撤销进行的操作
 */
- (void)disChoosedImageHandle
{
   [self.chooseImageView setImage:self.normalImage forState:UIControlStateNormal];
    
    //变化状态
    self.choosedType = CellChoosedTypeOff;
    
    //执行回调
    self.disTapBlock();
}


#pragma mark - 

/**
 *  设置约束
 */
- (void)startAutoLayout
{
    //水平约束
    NSArray * hor1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_photoImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_photoImageView)];
    NSArray * hor2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_chooseImageView(20)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_chooseImageView)];
    
    //垂直约束
    NSArray * ver1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_photoImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_photoImageView)];
    NSArray * ver2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_chooseImageView(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_chooseImageView)];
    
    //添加约束
    [self addConstraints:hor1];
    [self addConstraints:hor2];
    [self addConstraints:ver1];
    [self addConstraints:ver2];
}



@end
