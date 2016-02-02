//
//  TNCImagePickerViewController.h
//  Toon
//
//  Created by chengs on 15/11/10.
//  Copyright © 2015年 思源. All rights reserved.
//




#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class MMAssetsImagePickerViewController;
@protocol MMAssetsImagePickerViewControllerDelegate <NSObject>

@optional
- (void)qb_imagePickerController:(MMAssetsImagePickerViewController *)imagePickerController didSelectAssets:(NSArray *)assets;
@end


@interface MMAssetsImagePickerViewController : UIViewController

@property (nonatomic, weak) id<MMAssetsImagePickerViewControllerDelegate> delegate;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, copy) NSArray *groupTypes;
@property (nonatomic, assign) BOOL  isFrist;

+ (BOOL)isAccessible;

@end
