//
//  TableViewCell.m
//  Saint Portal
//
//  Created by David Foster on 12/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "PersonalDetailsHeaderCell.h"

@interface PersonalDetailsHeaderCell ()
@property (strong, nonatomic) IBOutlet UIImageView *IDImage;
@end

@implementation PersonalDetailsHeaderCell

- (void)awakeFromNib {
    
    self.IDImage.layer.cornerRadius = self.IDImage.frame.size.width/2;
    self.IDImage.clipsToBounds = YES;
    self.IDImage.layer.borderWidth = 3.0f;
    self.IDImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
