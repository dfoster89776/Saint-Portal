//
//  UpcominCourseworkTableViewCell.h
//  Saint Portal
//
//  Created by David Foster on 24/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpcomingCourseworkTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *courseworkModuleLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseworkNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseworkDuedateLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseworkToGoNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseworkToGoUnitsLabel;

@end
