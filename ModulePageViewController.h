//
//  DashboardViewController.h
//  Saint Portal
//
//  Created by David Foster on 13/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Modules.h"

@interface ModulePageViewController : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) Modules *module;
@end
