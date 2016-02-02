//
//  MMImagePickerGroupCell.h
//  TNNPhotoKitLibrary
//
//  Created by 程国帅 on 15/8/11.
//  Copyright (c) 2015年 程国帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MMImagePickerGroupCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (strong, nonatomic) IBOutlet UIImageView *imageView3;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, assign) CGFloat borderWidth;

@end
