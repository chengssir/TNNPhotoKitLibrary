//
//  TNCImagePickerViewController.m
//  Toon
//
//  Created by chengs on 15/11/10.
//  Copyright © 2015年 思源. All rights reserved.
//

#import "MMAssetsImagePickerViewController.h"
#import "MMAssetsAlbumViewController.h"

@interface MMAssetsImagePickerViewController ()

@property (nonatomic, strong) UINavigationController *albumsNavigationController;
@property (nonatomic, strong, readwrite) NSMutableOrderedSet *selectedAssetURLs;

@end

@implementation MMAssetsImagePickerViewController
+ (BOOL)isAccessible
{
    return ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] &&
            [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]);
}
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Set default values
        self.groupTypes = @[@(ALAssetsGroupSavedPhotos),
                            @(ALAssetsGroupPhotoStream),
                            @(ALAssetsGroupAlbum)
                            ];
        
        self.assetsLibrary = [ALAssetsLibrary new];
        self.selectedAssetURLs = [NSMutableOrderedSet orderedSet];
        self.isFrist = YES;
        [self setUpAlbumsViewController];
        
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if (*stop) {
                    //点击“好”回调方法:这里是重点
                    NSLog(@"好");
                    [self setUpAlbumsViewController];
                    MMAssetsAlbumViewController *albumsViewController = (MMAssetsAlbumViewController *)self.albumsNavigationController.topViewController;
                    albumsViewController.imagePickerController = self;
                    return;
                }
                *stop = TRUE;
            } failureBlock:^(NSError *error) {
                //点击“不允许”回调方法:这里是重点
                [self authorizationStatusALAssetsLibrary];
                NSLog(@"不允许");
                
            }];
        }else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
            
            MMAssetsAlbumViewController *albumsViewController = (MMAssetsAlbumViewController *)self.albumsNavigationController.topViewController;
            albumsViewController.imagePickerController = self;
            
        }else{
            NSLog(@"不允许");
            [self authorizationStatusALAssetsLibrary];
            
        }
        
    }
    
    return self;
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

- (void)setUpAlbumsViewController
{
    MMAssetsAlbumViewController *albumsViewController = [[MMAssetsAlbumViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:albumsViewController];
    
    [self addChildViewController:navigationController];
    
    navigationController.view.frame = self.view.bounds;
    [self.view addSubview:navigationController.view];
    
    [navigationController didMoveToParentViewController:self];
    
    self.albumsNavigationController = navigationController;
}
@end
