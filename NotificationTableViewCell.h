//
//  NotificationTableViewCell.h
//  Saint Portal
//
//  Created by David Foster on 12/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *notificationMessageLabel;
@property (strong, nonatomic) IBOutlet UIView *notificationReadView;


@end
