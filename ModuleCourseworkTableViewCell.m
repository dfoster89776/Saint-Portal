//
//  ModuleCourseworkTableViewCell.m
//  Saint Portal
//
//  Created by David Foster on 16/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "ModuleCourseworkTableViewCell.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

@implementation ModuleCourseworkTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    UIView *leftBorder = [UIView new];
    leftBorder.backgroundColor = UIColorFromRGB(0x00AEEF);
    leftBorder.frame = CGRectMake(0, 0, 1, self.outerContainerView.frame.size.height);
    [self.outerContainerView addSubview:leftBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
