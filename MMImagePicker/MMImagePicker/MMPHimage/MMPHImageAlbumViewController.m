//
//  MMPHImageAlbumViewController.m
//  Toon
//
//  Created by 程国帅 on 16/1/29.
//  Copyright © 2016年 思源. All rights reserved.
//

#import "MMPHImageAlbumViewController.h"
#import <Photos/Photos.h>
#import "MMSetBarButtonItem.h"
#import "MMPHImagePickerViewController.h"
#import "MMImagePickerGroupCell.h"
#import "MMPHImageAssetsViewController.h"

static CGSize CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

@interface MMPHImageAlbumViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, copy) NSArray *assetsGroups;
@property (nonatomic, copy) NSArray *fetchResults;
@property (nonatomic, copy) NSArray *assetCollections;

@end

@implementation MMPHImageAlbumViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    if ( [[UIDevice currentDevice].systemVersion floatValue] >= 7.0 ) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if (self.imagePickerController.isFrist) {
        self.imagePickerController.isFrist = NO;
        MMPHImageAssetsViewController *controller = [[MMPHImageAssetsViewController alloc] init];
        controller.imagePickerController = self.imagePickerController;
        [self.navigationController pushViewController:controller animated:NO];
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"相册"];
    
    [self.view addSubview:self.tableView];
    [self setUpToolbarItems];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    self.fetchResults = @[smartAlbums, userAlbums];
    [self updateAssetCollections];
    [self.tableView reloadData];

}


- (void)updateAssetCollections
{
    // Filter albums
    NSArray *assetCollectionSubtypes = self.imagePickerController.assetCollectionSubtypes;
    NSMutableDictionary *smartAlbums = [NSMutableDictionary dictionaryWithCapacity:assetCollectionSubtypes.count];
    NSMutableArray *userAlbums = [NSMutableArray array];
    
    for (PHFetchResult *fetchResult in self.fetchResults) {
        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
            PHAssetCollectionSubtype subtype = assetCollection.assetCollectionSubtype;
            
            if (subtype == PHAssetCollectionSubtypeAlbumRegular) {
                [userAlbums addObject:assetCollection];
            } else if ([assetCollectionSubtypes containsObject:@(subtype)]) {
                if (!smartAlbums[@(subtype)]) {
                    smartAlbums[@(subtype)] = [NSMutableArray array];
                }
                [smartAlbums[@(subtype)] addObject:assetCollection];
            }
        }];
    }
    
    NSMutableArray *assetCollections = [NSMutableArray array];
    
    // Fetch smart albums
    for (NSNumber *assetCollectionSubtype in assetCollectionSubtypes) {
        NSArray *collections = smartAlbums[assetCollectionSubtype];
        
        if (collections) {
            [assetCollections addObjectsFromArray:collections];
        }
    }
    
    // Fetch user albums
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
        [assetCollections addObject:assetCollection];
    }];
    
    self.assetCollections = assetCollections;
}


- (void)setUpToolbarItems
{
    UIBarButtonItem *backNavigationItem = [MMSetBarButtonItem barButtonItemWithTarget:self action:@selector(cancel:) normalImage:nil  highLightImage:nil title:@"取消" titleColor:nil frame:CGRectMake(0, 0, 15, 40)];
    self.navigationItem.leftBarButtonItem = backNavigationItem;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetCollections.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 86.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * indetify=@"cell";
    
    MMImagePickerGroupCell *cell=[tableView dequeueReusableCellWithIdentifier:indetify];
    if (cell==nil) {
        cell=[[MMImagePickerGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify];
    }
    cell.tag = indexPath.row;
    cell.borderWidth = 1.0 / [[UIScreen mainScreen] scale];

    // Thumbnail
    PHAssetCollection *assetCollection = self.assetCollections[indexPath.row];
    
    PHFetchOptions *options = [PHFetchOptions new];
    
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];

    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    if (fetchResult.count >= 3) {
        cell.imageView3.hidden = NO;
        
        [[PHImageManager defaultManager] requestImageForAsset:fetchResult[fetchResult.count - 3]
                                targetSize:CGSizeScale(cell.imageView3.frame.size, [[UIScreen mainScreen] scale])
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 if (cell.tag == indexPath.row) {
                                     cell.imageView3.image = result;
                                 }
                             }];
    } else {
        cell.imageView3.hidden = YES;
    }
    
    if (fetchResult.count >= 2) {
        cell.imageView2.hidden = NO;
        
        [imageManager requestImageForAsset:fetchResult[fetchResult.count - 2]
                                targetSize:CGSizeScale(cell.imageView2.frame.size, [[UIScreen mainScreen] scale])
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 if (cell.tag == indexPath.row) {
                                     cell.imageView2.image = result;
                                 }
                             }];
    } else {
        cell.imageView2.hidden = YES;
    }
    
    if (fetchResult.count >= 1) {
        [imageManager requestImageForAsset:fetchResult[fetchResult.count - 1]
                                targetSize:CGSizeScale(cell.imageView1.frame.size, [[UIScreen mainScreen] scale])
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 if (cell.tag == indexPath.row) {
                                     cell.imageView1.image = result;
                                 }
                             }];
    }
    
    if (fetchResult.count == 0) {
        cell.imageView3.hidden = NO;
        cell.imageView2.hidden = NO;
        
        // Set placeholder image
        UIImage *placeholderImage = [self placeholderImageWithSize:cell.imageView1.frame.size];
        cell.imageView1.image = placeholderImage;
        cell.imageView2.image = placeholderImage;
        cell.imageView3.image = placeholderImage;
    }
    
    // Album title
    cell.titleLabel.text = assetCollection.localizedTitle;
    
    // Number of photos
    cell.countLabel.text = [NSString stringWithFormat:@"%lu", (long)fetchResult.count];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMPHImageAssetsViewController *assetsViewController = [[MMPHImageAssetsViewController alloc]init];
    assetsViewController.imagePickerController = self.imagePickerController;
    assetsViewController.assetCollection =self.assetCollections[indexPath.row];
    [self.navigationController pushViewController:assetsViewController animated:YES];
}

- (UIImage *)placeholderImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *backgroundColor = [UIColor colorWithRed:(239.0 / 255.0) green:(239.0 / 255.0) blue:(244.0 / 255.0) alpha:1.0];
    UIColor *iconColor = [UIColor colorWithRed:(179.0 / 255.0) green:(179.0 / 255.0) blue:(182.0 / 255.0) alpha:1.0];
    
    // Background
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // Icon (back)
    CGRect backIconRect = CGRectMake(size.width * (16.0 / 68.0),
                                     size.height * (20.0 / 68.0),
                                     size.width * (32.0 / 68.0),
                                     size.height * (24.0 / 68.0));
    
    CGContextSetFillColorWithColor(context, [iconColor CGColor]);
    CGContextFillRect(context, backIconRect);
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(backIconRect, 1.0, 1.0));
    
    // Icon (front)
    CGRect frontIconRect = CGRectMake(size.width * (20.0 / 68.0),
                                      size.height * (24.0 / 68.0),
                                      size.width * (32.0 / 68.0),
                                      size.height * (24.0 / 68.0));
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(frontIconRect, -1.0, -1.0));
    
    CGContextSetFillColorWithColor(context, [iconColor CGColor]);
    CGContextFillRect(context, frontIconRect);
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(frontIconRect, 1.0, 1.0));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 添加右上角的名片图
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,  self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
