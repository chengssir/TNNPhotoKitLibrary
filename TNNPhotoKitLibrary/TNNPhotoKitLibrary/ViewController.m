//
//  ViewController.m
//  TNNPhotoKitLibrary
//
//  Created by 程国帅 on 15/8/10.
//  Copyright (c) 2015年 程国帅. All rights reserved.
//

#import "ViewController.h"
#import <MMImagePicker/MMImagePicker.h>
#import <Photos/Photos.h>
@interface ViewController ()<MMAssetsImagePickerViewControllerDelegate,MMPHImagePickerViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(30, 360, 90, 35);
    
    [btn setTitle:@"ZoomIn" forState:UIControlStateNormal];
    [btn setTitle:@"ZoomIn" forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(zoomInAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    
 
    
    

}

-(void)zoomInAction:(id)sender {
    
//    if ( [[UIDevice currentDevice].systemVersion floatValue] > 8.1 ) {
        MMPHImagePickerViewController * imagePickerController = [[MMPHImagePickerViewController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.maximumNumberOfSelection = 9;
        [self presentViewController:imagePickerController animated:YES completion:nil];
//
//        
//    }else{
//        MMAssetsImagePickerViewController * imagePickerController = [[MMAssetsImagePickerViewController alloc] init];
//        imagePickerController.delegate = self;
//        imagePickerController.maximumNumberOfSelection = 9;
//        [self presentViewController:imagePickerController animated:YES completion:nil];
        
//    }
 
}

- (void)MMPHImagePickerControllerDidFinish:(MMPHImagePickerViewController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    
    NSLog(@"--------%@",assets);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)qb_imagePickerController:(MMAssetsImagePickerViewController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSLog(@"--------%@",assets);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
