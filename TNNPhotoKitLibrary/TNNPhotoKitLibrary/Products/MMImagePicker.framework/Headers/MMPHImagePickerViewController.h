//
//  MMPHImagePickerViewController.h
//  Toon
//
//  Created by 程国帅 on 16/1/29.
//  Copyright © 2016年 思源. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class MMPHImagePickerViewController;

@protocol MMPHImagePickerViewControllerDelegate <NSObject>

@optional
- (void)MMPHImagePickerControllerDidFinish:(MMPHImagePickerViewController *)imagePickerController didFinishPickingAssets:(NSArray *)assets;

@end


#ifdef MEMORY_TEST_FLAG
#import "ImprovedViewController.h"
@interface MMPHImagePickerViewController : ImprovedViewController
#else
@interface MMPHImagePickerViewController : UIViewController
#endif

@property (nonatomic, weak) id<MMPHImagePickerViewControllerDelegate> delegate;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSUInteger numberOfColumnsInPortrait;
@property (nonatomic, assign) NSUInteger numberOfColumnsInLandscape;
@property (nonatomic, copy) NSArray *assetCollectionSubtypes;
@property (nonatomic, assign) BOOL  isFrist;

@end
