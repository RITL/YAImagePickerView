//
//  main.m
//  YChoosePicturesDemo
//
//  Created by YueWen on 16/3/30.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        } @catch (NSException *exception) {
            
            NSLog(@"name=%@,reason=%@",exception.name,exception.reason);
        } @finally {
            
        }
        

    }
}
