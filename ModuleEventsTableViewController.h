//
//  ModuleEventsTableViewController.h
//  Saint Portal
//
//  Created by David Foster on 15/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Modules.h"

@interface ModuleEventsTableViewController : UITableViewController
@property (strong, nonatomic) Modules * module;

-(Event *)getSelectedEvent;

@end
