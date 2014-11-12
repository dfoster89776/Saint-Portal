//
//  UpcominCourseworkTableViewCell.m
//  Saint Portal
//
//  Created by David Foster on 24/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "UpcomingCourseworkTableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

@interface UpcomingCourseworkTableViewCell()
@property (strong, nonatomic) IBOutlet UIView *DaysToGoView;
@end

@implementation UpcomingCourseworkTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    UIView *leftBorder = [UIView new];
    leftBorder.backgroundColor = UIColorFromRGB(0x00AEEF);
    leftBorder.frame = CGRectMake(0, 0, 1, self.DaysToGoView.frame.size.height);
    [self.DaysToGoView addSubview:leftBorder];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
