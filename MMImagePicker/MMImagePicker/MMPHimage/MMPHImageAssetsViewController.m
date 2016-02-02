//
//  MMPHImageAssetsViewController.m
//  Toon
//
//  Created by 程国帅 on 16/1/29.
//  Copyright © 2016年 思源. All rights reserved.
//
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define CELL_W  (SCREEN_W-10)/4

#import "MMPHImageAssetsViewController.h"
#import <Photos/Photos.h>
#import "MMAssetCollectionViewCell.h"
#import "MMPHImagePickerViewController.h"
#import "MBProgressHUD.h"
//#import "TNAChatMessageUtils.h"
#import "MMSetBarButtonItem.h"
@interface MMPHImageAssetsViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong, readwrite) NSMutableSet *selectedAssetURLs;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@end

@implementation MMPHImageAssetsViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.selectedAssetURLs = [NSMutableSet set];
    if ( [[UIDevice currentDevice].systemVersion floatValue] >= 7.0 ) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if (!_assetCollection) {
        PHFetchOptions *options = [PHFetchOptions new];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        self.fetchResult = [PHAsset fetchAssetsWithOptions:nil];
        [self.collectionView reloadData];
        [self scrollToItemAtIndexPath];
    }else{
        [self updateFetchRequest];
        [self.collectionView reloadData];
        [self scrollToItemAtIndexPath];
     }
    
}

-(void)scrollToItemAtIndexPath{
    if (self.fetchResult.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.fetchResult.count-1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }else{
        [self authorizationStatusALAssetsLibrary];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片";
    [self.view addSubview:self.collectionView];
    [self setUpToolbarItems];

}

- (void)setUpToolbarItems
{
    
    UIBarButtonItem *backNavigationItem = [MMSetBarButtonItem barButtonItemWithTarget:self action:@selector(cannel:) normalImage:@"header_icon_back"  highLightImage:@"header_icon_back" title:NSLocalizedString(@"相册", nil) titleColor:nil frame:CGRectMake(0, 0, 15, 40)];
    self.navigationItem.leftBarButtonItem = backNavigationItem;
    
    UIBarButtonItem *rightItem = [MMSetBarButtonItem barButtonItemWithTarget:self action:@selector(done:) normalImage:nil  highLightImage:nil title:NSLocalizedString(@"确定", nil) titleColor:nil frame:CGRectMake(0, 0, 15, 40)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled =NO;
    
}
- (PHCachingImageManager *)imageManager
{
    if (_imageManager == nil) {
        _imageManager = [PHCachingImageManager new];
    }
    
    return _imageManager;
}

- (void)setAssetCollection:(PHAssetCollection *)assetCollection
{
    _assetCollection = assetCollection;
    
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(CELL_W, CELL_W);//cell的大小
        layout.minimumLineSpacing = 2;//每行的间距
        layout.minimumInteritemSpacing = 2;//每行cell内部的间距
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, self.view.bounds.size.height-64) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[MMAssetCollectionViewCell class] forCellWithReuseIdentifier:@"MMAssetCollectionViewCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.allowsMultipleSelection = YES;
    }
    return _collectionView;
}

- (void)updateFetchRequest
{
    if (_assetCollection) {
        PHFetchOptions *options = [PHFetchOptions new];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        self.fetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:options];
    } else {
        self.fetchResult = nil;
        [self authorizationStatusALAssetsLibrary];

    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MMAssetCollectionViewCell" forIndexPath:indexPath];
    cell.tag = indexPath.item;
    PHAsset *asset = self.fetchResult[indexPath.item];
    [self.imageManager requestImageForAsset:asset
                                 targetSize:CGSizeMake(154, 142)
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  if (cell.tag == indexPath.item) {
                                      cell.imageView.image = result;
                                  }
                              }];
    
    if ([self.selectedAssetURLs containsObject:asset]){
        [cell setSelected:YES];
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self validateMaximumNumberOfSelections:(self.selectedAssetURLs.count + 1)]) {
        return YES;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"你最多只能选择%lu张图片",(unsigned long)self.imagePickerController.maximumNumberOfSelection] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确认", nil), nil];
    [alert show];
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = self.fetchResult[indexPath.item];
    [self.selectedAssetURLs addObject:asset];
    
    self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.selectedAssetURLs.count)];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = self.fetchResult[indexPath.item];
    [self.selectedAssetURLs removeObject:asset];
    
    self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.selectedAssetURLs.count)];
    
}

- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, 1);
    
    if (minimumNumberOfSelection <= self.imagePickerController.maximumNumberOfSelection) {
        return (numberOfSelections <= self.imagePickerController.maximumNumberOfSelection);
    }
    
    return YES;
}

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, 1);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.imagePickerController.maximumNumberOfSelection) {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.imagePickerController.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}


- (void)authorizationStatusALAssetsLibrary
{
    //    若要启用手机通讯录，请先进入手机的“设置--隐私--通讯录”开启授权。
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height/5, [UIScreen mainScreen].bounds.size.width-40, 60)];
    label.text = @"无照片,拍照与朋友分享吧!";
    label.numberOfLines = 0;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:label];
    
}

- (void)cannel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
 
}

- (void)fetchAssetsFromSelectedAssetURLsWithCompletion:(void (^)(NSArray *assets))completion
{
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    __block NSMutableArray *assets = [NSMutableArray array];
    for (PHAsset *selectedAssetURL in self.selectedAssetURLs) {
        [imageManager  requestImageDataForAsset:selectedAssetURL options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            UIImage *uiima  = [UIImage imageWithData:imageData];
//            NSString * picUrl = [TNAChatMessageUtils stringWithPhotoImage:uiima];
            [assets addObject:uiima];
            if (assets.count == self.selectedAssetURLs.count) {
                completion(assets);
            }
        }];
    }
    
}


- (void)done:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if ([self.imagePickerController.delegate respondsToSelector:@selector(MMPHImagePickerControllerDidFinish:didFinishPickingAssets:)]) {
        [self fetchAssetsFromSelectedAssetURLsWithCompletion:^(NSArray *assets) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.imagePickerController.delegate MMPHImagePickerControllerDidFinish:self.imagePickerController
                                                   didFinishPickingAssets:assets];
        }];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }


@end
