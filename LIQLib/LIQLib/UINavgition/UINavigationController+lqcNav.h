//
//  UINavigationController+lqcNav.h
//  LIQLib
//
//  Created by LQ_MAC on 16/4/22.
//  Copyright © 2016年 LQ_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (lqcNav)


+ (void)lqc_navRegister;


- (void)pushViewControllerAndRemoveTopWithContoller:(UIViewController *)viewController  animated:(BOOL)animated;

/*
 * 先pop到classname对应的controller，然后再把controller压进去，使用self来遍历
 */
- (void)pushToTopClassName:(NSString *)className
            withController:(UIViewController *)controller;

@end


@interface UIViewController (Login)

@property (nonatomic, assign ) BOOL needRemoveWhenPushOtherViewController;

@end