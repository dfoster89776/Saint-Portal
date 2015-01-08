//
//  DashboardUpcomingEventsTableViewController.h
//  Saint Portal
//
//  Created by David Foster on 26/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface DashboardUpcomingEventsTableViewController : UITableViewController
-(Event *)getSelectedEvent;
@end
