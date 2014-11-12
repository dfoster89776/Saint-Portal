//
//  ModuleViewController.h
//  Saint Portal
//
//  Created by David Foster on 09/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Modules.h"

@interface ModuleViewController : UIViewController

@property (strong, nonatomic) NSString *moduleName;
@property (strong, nonatomic) Modules *module;

@end
