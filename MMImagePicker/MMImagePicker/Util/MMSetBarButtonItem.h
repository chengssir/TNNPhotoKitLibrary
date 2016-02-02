//
//  MMSetBarButtonItem.h
//  Toon
//
//  Created by chengs on 15/11/10.
//  Copyright © 2015年 思源. All rights reserved.
//


#define KBarButtonWidth 15
#define KBarButtonHeight 40
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MMSetBarButtonItem : NSObject
+ (UIBarButtonItem *)barButtonItemWithTarget:(id)target
                                      action:(SEL)selector
                                 normalImage:(NSString *)normalImgName
                              highLightImage:(NSString *) highLightImageName
                                       title:(NSString *)title
                                  titleColor:(UIColor *)titleColor
                                       frame:(CGRect)frame;
+ (UIBarButtonItem *)headBarButtonItemWithTarget:(id)target
                                      action:(SEL)selector
                                 normalImage:(NSString *)normalImgName
                              highLightImage:(NSString *) highLightImageName
                                       title:(NSString *)title
                                  titleColor:(UIColor *)titleColor
                                       frame:(CGRect)frame;
@end
