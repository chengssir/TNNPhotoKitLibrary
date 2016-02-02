//
//  MMAlbumViewController.m
//  Toon
//
//  Created by chengs on 15/11/10.
//  Copyright © 2015年 思源. All rights reserved.
//
#define ScreenFrameWidth [UIScreen mainScreen].applicationFrame.size.width
#define ScreenBoundHeight [UIScreen mainScreen].bounds.size.height

#import "MMAssetsAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MMImagePickerGroupCell.h"
#import "MMAssetsAssetsViewController.h"
#import "MMAssetsImagePickerViewController.h"
#import "MMSetBarButtonItem.h"

@interface MMAssetsAlbumViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, copy) NSArray *assetsGroups;

@end

@implementation MMAssetsAlbumViewController

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
        MMAssetsAssetsViewController *controller = [[MMAssetsAssetsViewController alloc] init];
        controller.imagePickerController = self.imagePickerController;
        [self.navigationController pushViewController:controller animated:NO];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"相册"];
    
    [self.view addSubview:self.tableView];
    [self setUpToolbarItems];
    
    [self updateAssetsGroupsWithCompletion:^{
        [self.tableView reloadData];
    }];
    
}
- (void)setUpToolbarItems
{
    UIBarButtonItem *backNavigationItem = [MMSetBarButtonItem barButtonItemWithTarget:self action:@selector(cancel:) normalImage:nil  highLightImage:nil title:@"取消" titleColor:nil frame:CGRectMake(0, 0, 15, 40)];
    self.navigationItem.leftBarButtonItem = backNavigationItem;

}

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)updateAssetsGroupsWithCompletion:(void (^)(void))completion
{
    [self fetchAssetsGroupsWithTypes:self.imagePickerController.groupTypes completion:^(NSArray *assetsGroups) {
        // Map assets group to dictionary
        NSMutableDictionary *mappedAssetsGroups = [NSMutableDictionary dictionaryWithCapacity:assetsGroups.count];
        for (ALAssetsGroup *assetsGroup in assetsGroups) {
            
            NSMutableArray *array = mappedAssetsGroups[[assetsGroup valueForProperty:ALAssetsGroupPropertyType]];
            if (!array) {
                array = [NSMutableArray array];
            }
            
            [array addObject:assetsGroup];
            
            mappedAssetsGroups[[assetsGroup valueForProperty:ALAssetsGroupPropertyType]] = array;
        }
        
        // Pick the groups to be shown
        NSMutableArray *sortedAssetsGroups = [NSMutableArray arrayWithCapacity:3];
        
        for (NSValue *groupType in self.imagePickerController.groupTypes) {
            NSArray *array = mappedAssetsGroups[groupType];
            if (array) {
                [sortedAssetsGroups addObjectsFromArray:array];
            }
        }
        
        self.assetsGroups = sortedAssetsGroups;
        
        if (completion) {
            completion();
        }
    }];

}

- (void)fetchAssetsGroupsWithTypes:(NSArray *)types completion:(void (^)(NSArray *assetsGroups))completion
{
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    
    ALAssetsFilter *assetsFilter  = [ALAssetsFilter allAssets];
    
    for (NSNumber *type in types) {
        [self.imagePickerController.assetsLibrary enumerateGroupsWithTypes:[type unsignedIntegerValue]
                                     usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
                                             NSUInteger numberOfAssets = MIN(3, [assetsGroup numberOfAssets]);
                                         NSLog(@"--%lu",(unsigned long)numberOfAssets);
                                         if ([assetsGroup numberOfAssets] > 0) {
                                             // Apply assets filter
                                             [assetsGroup setAssetsFilter:assetsFilter];
                                             
                                             // Add assets group
                                             [assetsGroups addObject:assetsGroup];
                                         } else {
                                             numberOfFinishedTypes++;
                                         }
                                         if (numberOfFinishedTypes == types.count) {
                                             if (completion) {
                                                 completion(assetsGroups);
                                             }
                                         }
                                     } failureBlock:^(NSError *error) {
                                         NSLog(@"Error: %@", [error localizedDescription]);
                                     }];
    }

}

#pragma mark - 添加右上角的名片图
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenFrameWidth, ScreenBoundHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
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
    cell.borderWidth = 1.0 / [[UIScreen mainScreen] scale];
    
    // Thumbnail
    ALAssetsGroup *assetsGroup = self.assetsGroups[indexPath.row];
    
    NSUInteger numberOfAssets = MIN(3, [assetsGroup numberOfAssets]);
    
    if (numberOfAssets > 0) {
        NSRange range = NSMakeRange([assetsGroup numberOfAssets] - numberOfAssets, numberOfAssets);
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:range];
        
        cell.imageView3.hidden = YES;
        cell.imageView2.hidden = YES;
        
        [assetsGroup enumerateAssetsAtIndexes:indexes options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (!result) return;
            CGImageRef thumbnailRef = [result thumbnail];
            if (!thumbnailRef) return;
            UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailRef];
            
            if (index == NSMaxRange(range) - 1) {
                cell.imageView1.hidden = NO;
                cell.imageView1.image = thumbnail;
            } else if (index == NSMaxRange(range) - 2) {
                cell.imageView2.hidden = NO;
                cell.imageView2.image = thumbnail;
            } else {
                cell.imageView3.hidden = NO;
                cell.imageView3.image = thumbnail;
            }
        }];
    } else {
        cell.imageView3.hidden = NO;
        cell.imageView2.hidden = NO;
        
        // Set placeholder image
        UIImage *placeholderImage = [self placeholderImageWithSize:cell.imageView1.frame.size];
        cell.imageView1.image = placeholderImage;
        cell.imageView2.image = placeholderImage;
        cell.imageView3.image = placeholderImage;
    }
    
    // Album title
    cell.titleLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    // Number of photos
    cell.countLabel.text = [NSString stringWithFormat:@"%lu", (long)assetsGroup.numberOfAssets];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMAssetsAssetsViewController *assetsViewController = [[MMAssetsAssetsViewController alloc]init];
    assetsViewController.imagePickerController = self.imagePickerController;
    assetsViewController.assetsGroup = self.assetsGroups[indexPath.row];    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
