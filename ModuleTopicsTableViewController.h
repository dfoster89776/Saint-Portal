//
//  ModuleTopicsTableViewController.h
//  Saint Portal
//
//  Created by David Foster on 30/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Modules.h"

@interface ModuleTopicsTableViewController : UITableViewController
@property (nonatomic, strong)Modules *module;

-(Topics *)getSelectedTopic;

@end
