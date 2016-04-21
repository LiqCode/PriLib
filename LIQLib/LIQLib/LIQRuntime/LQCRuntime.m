//
//  LQCRuntime.m
//  LIQLib
//
//  Created by LQ_MAC on 16/4/22.
//  Copyright © 2016年 LQ_MAC. All rights reserved.
//

#import "LQCRuntime.h"


@implementation LQCRuntime

static inline void lqc_swizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

static inline BOOL lqc_addMethod(Class theClass, SEL selector, Method method) {
    return class_addMethod(theClass, selector,  method_getImplementation(method),  method_getTypeEncoding(method));
}

@end
