//
//  TNNPhotosCollectionViewCell.m
//  TNNPhotoKitLibrary
//
//  Created by 程国帅 on 15/8/10.
//  Copyright (c) 2015年 程国帅. All rights reserved.
//

#import "MMAssetCollectionViewCell.h"
#import "MMAssetOverlayView.h"
@interface MMAssetCollectionViewCell ()

@property (nonatomic, strong) MMAssetOverlayView *overlayView;

@end

@implementation MMAssetCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode =  UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        [self getoverlayView];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.overlayView.hidden = !selected;

}

- (void)getoverlayView
{
        _overlayView = [[MMAssetOverlayView alloc] initWithFrame:self.contentView.bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.hidden = YES;
        [self.contentView addSubview:_overlayView];
}

//#pragma mark - Accessors
//
//- (void)image:(UIImage *)image
//{
//
//    self.imageView.image = image;
//
//}
@end
