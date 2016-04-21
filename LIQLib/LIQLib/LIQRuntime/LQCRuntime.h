//
//  LQCRuntime.h
//  LIQLib
//
//  Created by LQ_MAC on 16/4/22.
//  Copyright © 2016年 LQ_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface LQCRuntime : NSObject

static inline void lqc_swizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector);

static inline BOOL lqc_addMethod(Class theClass, SEL selector, Method method);

@end
