//
//  YPhotoBrowseViewController.m
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/4/19.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPhotoBrowseViewController.h"

@interface YPhotoBrowseViewController ()<UIScrollViewDelegate>

//负责只显示一个当前图
@property (nonatomic, strong) UIImageView * tempImageView;

@end

@implementation YPhotoBrowseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //添加组件
    [self.view addSubview:self.tempImageView];

}

-(void)viewWillAppear:(BOOL)animated
{
    //设置大图
    UIImage * image = [UIImage imageWithCGImage:self.currentAsset.defaultRepresentation.fullScreenImage];
    
    self.tempImageView.image = image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Getter

//显示的视图
-(UIImageView *)tempImageView
{
    if (_tempImageView == nil)
    {
        _tempImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _tempImageView.contentMode = UIViewContentModeScaleAspectFit;
        _tempImageView.backgroundColor = [UIColor blackColor];
    }
    return _tempImageView;
}



@end
