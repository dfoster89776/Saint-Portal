//
//  DashboardPageViewController.h
//  Saint Portal
//
//  Created by David Foster on 13/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardPageViewController : UIViewController <UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;

- (IBAction)startWalkthrough:(id)sender;
@end

