//
//  YPhotoNavigationController.m
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/4/15.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPhotoNavigationController.h"
#import "YGroupTableViewController.h"

@interface YPhotoNavigationController ()

@property (nonatomic, copy) ImagesBlock imagesBlock; //代码块属性

@end

@implementation YPhotoNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setTranslucent:true];
    

    //获得storyBoard对象
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    //获得组控制器
    YGroupTableViewController * groupTableViewController = (YGroupTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"YGroupTableViewController"];
    
    //设置回调
    [groupTableViewController imageDidSelect:^(NSArray<UIImage *> * images) {
        
        //进行回调
        self.imagesBlock(images);
        
    }];
    
    //设置类型
    groupTableViewController.photoSequenceType = self.photoSequenceType;
    
    self.viewControllers = @[groupTableViewController];
    
    //迅速跳转至所有图片
    [groupTableViewController pushToAllPhotosCollectionViewController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

//设置回调
- (void)imageDidSelect:(void (^)(NSArray <UIImage *> *)) images
{
    self.imagesBlock = images;
}



@end
