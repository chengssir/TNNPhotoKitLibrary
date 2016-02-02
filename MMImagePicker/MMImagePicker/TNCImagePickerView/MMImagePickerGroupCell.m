//
//  MMImagePickerGroupCell.m
//  TNNPhotoKitLibrary
//
//  Created by 程国帅 on 15/8/11.
//  Copyright (c) 2015年 程国帅. All rights reserved.
//

#import "MMImagePickerGroupCell.h"
@interface MMImagePickerGroupCell ()
@end

@implementation MMImagePickerGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(16, 7, 68, 72);
        [self.contentView addSubview:view];
        
        self.imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(4, 0, 60, 60)];
        [view addSubview:self.imageView3];
        self.imageView3.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView3.clipsToBounds = YES;

        self.imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 64, 64)];
        [view addSubview:self.imageView2];
        self.imageView2.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView2.clipsToBounds = YES;

        self.imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 4, 68, 68)];
        [view addSubview:self.imageView1];
        self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView1.clipsToBounds = YES;

        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(102, 22, 220, 21)];
        self.countLabel.font = [UIFont systemFontOfSize:17.0];
        [self.contentView addSubview:self.titleLabel];

        self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(102, 46, 220, 21)];
        self.countLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:self.countLabel];
  
      }
    
    return self;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    
    self.imageView1.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView1.layer.borderWidth = borderWidth;
    
    self.imageView2.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView2.layer.borderWidth = borderWidth;
    
    self.imageView3.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView3.layer.borderWidth = borderWidth;
}


@end
