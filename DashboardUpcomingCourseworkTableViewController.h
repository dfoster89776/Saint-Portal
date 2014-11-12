//
//  DashboardUpcomingCourseworkTableViewController.h
//  Saint Portal
//
//  Created by David Foster on 24/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coursework.h"

@interface DashboardUpcomingCourseworkTableViewController : UITableViewController
-(Coursework *)getSelectedCourseworkItem;
@end
