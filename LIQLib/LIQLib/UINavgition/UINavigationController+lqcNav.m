//
//  UINavigationController+lqcNav.m
//  LIQLib
//
//  Created by LQ_MAC on 16/4/22.
//  Copyright © 2016年 LQ_MAC. All rights reserved.
//

#import "UINavigationController+lqcNav.h"
#import "LQCRuntime.h"

#define kLQCNavigateLoginRemoveKey @"com.LIQ.kLQCNavigateLoginRemoveKey"

@implementation UINavigationController (lqcNav)

+ (void)lqc_navRegister
{
    Method originalMethod = class_getInstanceMethod([UINavigationController class], @selector(pushViewController:animated:));
    Method swizzledMethod = class_getInstanceMethod([UINavigationController class], @selector(lqcswizzled_pushViewController:animated:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    
}

- (void)lqc_popViewControllerAnimated:(BOOL)animated;
{
    [self popViewControllerAnimated:animated];
}

- (void)lqcswizzled_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    if (viewController == nil) {
        NSAssert(false, @"viewController 不能为空");
        return;
    }
    
    [self lqcswizzled_pushViewController:viewController animated:animated];
    NSInteger count = [self.viewControllers count];
    
    NSMutableArray *viewControllers = [self.viewControllers mutableCopy];
    if (count > 2) {
        for (int i = 1; i < count - 1; i++) {
            UIViewController *vc = self.viewControllers[i];
            
            if ([vc respondsToSelector:@selector(needRemoveWhenPushOtherViewController)] &&
                [vc needRemoveWhenPushOtherViewController]) {
                
                [viewControllers removeObject:vc];
            }
        }
        
        self.viewControllers = viewControllers;
    }
}


- (void)pushViewControllerAndRemoveTopWithContoller:(UIViewController *)viewController  animated:(BOOL)animated {
    if (viewController == nil) {
        NSAssert(false, @"viewController 不能为空");
        return;
    }
    
    [self pushViewController:viewController animated:animated];
    NSInteger count = [self.viewControllers count];
    
    if (count > 2) {
        NSMutableArray *viewControllers = [self.viewControllers mutableCopy];
        NSInteger index = viewControllers.count - 2;
        [viewControllers removeObjectAtIndex:index];
        self.viewControllers = viewControllers;
    }
}

/*
 * 先pop到classname对应的controller，然后再把controller压进去，使用self来遍历
 */
- (void)pushToTopClassName:(NSString *)className
            withController:(UIViewController *)controller
{
    if (controller == nil || className == nil || [className length] < 1) {
        return;
    }
    UIViewController *topController = nil;
    for (NSInteger i = [self.viewControllers count] - 1; i >= 0; i--) {
        UIViewController *controller = [self.viewControllers objectAtIndex:i];
        if ([controller isKindOfClass:NSClassFromString(className)]) {
            topController = controller;
            break;
        }
    }
    if (topController) {
        [self popToViewController:topController animated:NO];
        [self pushViewController:controller animated:YES];
    } else {
        [self popToRootViewControllerAnimated:YES];
        [self pushViewController:controller animated:YES];
    }
}

- (void)popToViewControllerWithClassName:(NSString *)className
                                animated:(BOOL)animated {
    if (className == nil || [className length] < 1) {
        return;
    }
    
    UIViewController *topController = nil;
    for (NSInteger i = [self.viewControllers count] - 1; i >= 0; i--) {
        UIViewController *controller = [self.viewControllers objectAtIndex:i];
        if ([controller isKindOfClass:NSClassFromString(className)]) {
            topController = controller;
            break;
        }
    }
    
    if (topController) {
        [self popToViewController:topController animated:animated];
    } else {
        [self popToRootViewControllerAnimated:animated];
    }
}

@end

@implementation UIViewController (lqcNav)

- (BOOL)needRemoveWhenPushOtherViewController
{
    id num = objc_getAssociatedObject(self, kLQCNavigateLoginRemoveKey);
    if (num && [num isKindOfClass:[NSNumber class]]) {
        return [num boolValue];
    }
    return NO;
}

- (void)setNeedRemoveWhenPushOtherViewController:(BOOL)needRemoveWhenPushOtherViewController
{
    NSNumber *num = [NSNumber numberWithBool:needRemoveWhenPushOtherViewController];
    objc_setAssociatedObject(self, kLQCNavigateLoginRemoveKey, num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
