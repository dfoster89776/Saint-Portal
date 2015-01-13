//
//  TabBarViewController.h
//  Saint Portal
//
//  Created by David Foster on 11/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController

-(void)updateBadgeCount:(NSNotification *)notification;

@end
