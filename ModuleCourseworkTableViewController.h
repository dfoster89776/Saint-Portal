//
//  ModuleCourseworkTableViewController.h
//  Saint Portal
//
//  Created by David Foster on 16/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Modules.h"
#import "Coursework.h"

@interface ModuleCourseworkTableViewController : UITableViewController

@property (nonatomic, strong)Modules *module;

-(Coursework *)getSelectedCourseworkItem;


@end
