//
//  ModuleEventTableViewCell.m
//  Saint Portal
//
//  Created by David Foster on 26/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "ModuleEventTableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]


@implementation ModuleEventTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    UIView *rightBorder = [UIView new];
    rightBorder.backgroundColor = UIColorFromRGB(0x00AEEF);;
    rightBorder.frame = CGRectMake(self.timeView.frame.size.width, 0, 1, self.timeView.frame.size.height);
    [self.timeView addSubview:rightBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellEventDetails:(Event *)event{
    
    NSLog(@"Updating cell details: %@", event.event_module);
    
}

@end
