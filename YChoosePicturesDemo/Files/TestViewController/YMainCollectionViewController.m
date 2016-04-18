//
//  YMainCollectionViewController.m
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/4/15.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YMainCollectionViewController.h"
#import "YPhotoCollectionViewCell.h"
#import "YPhotoNavigationController.h"

@interface YMainCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) CGFloat size;//标准大小
@property (nonatomic, copy) NSArray <UIImage *> * images;//存储图片的数组

@end

@implementation YMainCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.size = (self.view.bounds.size.width - 3) / 4.0f;
    self.images = @[];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.images.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    YPhotoCollectionViewCell *cell = (YPhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.photoImageView.image = self.images[indexPath.item];
    
    return cell;
}



#pragma mark <UICollectionViewDelegateFlowLayout>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.size, self.size);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}


#pragma mark - Add Action

- (IBAction)addPhotoAction:(id)sender
{
    //初始化照片选择器
    YPhotoNavigationController * choosePhotoController = [[YPhotoNavigationController alloc]init];
    
    //设置回调
    [choosePhotoController imageDidSelect:^(NSArray<UIImage *> * images) {
        
        self.images = images;
        [self.collectionView reloadData];
        
    }];
    
    //设置类型-(默认按照选择熟悉排列，下面设置是按照片在相册的顺序排列)
//    choosePhotoController.photoSequenceType = YChoosePhotoSequenceTypeDate;
    
    //模态跳出
    [self presentViewController:choosePhotoController animated:true completion:^{}];
    
}

@end
