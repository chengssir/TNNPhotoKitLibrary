//
//  MMAssetOverlayView.m
//  TNNPhotoKitLibrary
//
//  Created by 程国帅 on 15/8/10.
//  Copyright (c) 2015年 程国帅. All rights reserved.
//

#import "MMAssetOverlayView.h"
#import "MMAssetCheckMarkView.h"
#import <QuartzCore/QuartzCore.h>

@interface MMAssetOverlayView ()

@property (nonatomic, strong) MMAssetCheckMarkView *checkmarkView;

@end
@implementation MMAssetOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // View settings
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        
        // 创建选中层
        MMAssetCheckMarkView *checkmarkView = [[MMAssetCheckMarkView alloc] initWithFrame:CGRectMake(self.bounds.size.width - (4.0 + 24.0), self.bounds.size.height - (4.0 + 24.0), 24.0, 24.0)];
        checkmarkView.autoresizingMask = UIViewAutoresizingNone;
        
        checkmarkView.layer.shadowColor = [[UIColor grayColor] CGColor];
        checkmarkView.layer.shadowOffset = CGSizeMake(0, 0);
        checkmarkView.layer.shadowOpacity = 0.6;
        checkmarkView.layer.shadowRadius = 2.0;
        
        [self addSubview:checkmarkView];
        self.checkmarkView = checkmarkView;
    }
    
    return self;
}

@end
