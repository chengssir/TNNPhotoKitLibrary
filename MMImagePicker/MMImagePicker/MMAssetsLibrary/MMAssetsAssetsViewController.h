//
//  TNCAssetsViewController.h
//  Toon
//
//  Created by chengs on 15/11/10.
//  Copyright © 2015年 思源. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAssetsGroup;
@class MMAssetsImagePickerViewController;
@interface MMAssetsAssetsViewController : UIViewController
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) MMAssetsImagePickerViewController *imagePickerController;

@end
