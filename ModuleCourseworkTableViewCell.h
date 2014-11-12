//
//  ModuleCourseworkTableViewCell.h
//  Saint Portal
//
//  Created by David Foster on 16/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleCourseworkTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *CourseworkNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *CourseworkDueDateLabel;
@property (strong, nonatomic) IBOutlet UIView *outerContainerView;
@property (strong, nonatomic) IBOutlet UILabel *courseworkToGoNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseworkToGoUnitsLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightingLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseworkDueTimeLabel;

@end
