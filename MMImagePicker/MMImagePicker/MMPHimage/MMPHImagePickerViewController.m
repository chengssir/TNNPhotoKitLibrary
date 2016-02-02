//
//  MMPHImagePickerViewController.m
//  Toon
//
//  Created by 程国帅 on 16/1/29.
//  Copyright © 2016年 思源. All rights reserved.
//

#import "MMPHImagePickerViewController.h"
#import "MMPHImageAlbumViewController.h"

@interface MMPHImagePickerViewController ()
@property (nonatomic, strong, readwrite) NSMutableOrderedSet *selectedAssetURLs;
@property (nonatomic, strong) UINavigationController *albumsNavigationController;

@end

@implementation MMPHImagePickerViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Set default values
        self.assetCollectionSubtypes = @[
                                         @(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                         @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
                                         @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
                                         @(PHAssetCollectionSubtypeSmartAlbumBursts)
                                         ];
        self.numberOfColumnsInPortrait = 4;
        self.numberOfColumnsInLandscape = 7;
        
        self.selectedAssetURLs = [NSMutableOrderedSet orderedSet];
        self.isFrist = YES;
        [self setUpAlbumsViewController];
        
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case   PHAuthorizationStatusNotDetermined:
                {
                    MMPHImageAlbumViewController *albumsViewController = (MMPHImageAlbumViewController *)self.albumsNavigationController.topViewController;
                    albumsViewController.imagePickerController = self;
                    
                }
                    break;
                    
                case PHAuthorizationStatusAuthorized:
                {

                    MMPHImageAlbumViewController *albumsViewController = (MMPHImageAlbumViewController *)self.albumsNavigationController.topViewController;
                    albumsViewController.imagePickerController = self;

                }
                    break;
                default:
                {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self authorizationStatusALAssetsLibrary];
                    });
                    
                    
                }
                    break;
            }
        }];

    }
    
    return self;
}

- (void)setUpAlbumsViewController
{
    MMPHImageAlbumViewController *albumsViewController = [[MMPHImageAlbumViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:albumsViewController];
    
    [self addChildViewController:navigationController];
    
    navigationController.view.frame = self.view.bounds;
    [self.view addSubview:navigationController.view];
    
    [navigationController didMoveToParentViewController:self];
    
    self.albumsNavigationController = navigationController;
}

- (void)authorizationStatusALAssetsLibrary
{
    //    若要启用手机通讯录，请先进入手机的“设置--隐私--通讯录”开启授权。
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width-40, 60)];
    label.text = @"请在iPhone的“设置-隐私-相册”选项中，允许toon访问你的手机相册。";
    label.numberOfLines = 0;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:label];
    
}
@end
