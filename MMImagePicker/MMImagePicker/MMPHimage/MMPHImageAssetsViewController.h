//
//  MMPHImageAssetsViewController.h
//  Toon
//
//  Created by 程国帅 on 16/1/29.
//  Copyright © 2016年 思源. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMPHImagePickerViewController;
@class PHAssetCollection;

@interface MMPHImageAssetsViewController : UIViewController

@property (nonatomic, strong) MMPHImagePickerViewController *imagePickerController;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
