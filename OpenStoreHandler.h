//
//  OpenStoreHandler.h
//  Saint Portal
//
//  Created by David Foster on 12/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"
#import "Directory.h"
#import <UIKit/UIKit.h>

@interface OpenStoreHandler : NSObject
-(void)openFile:(File*)file withCurrentView:(UIViewController *)current;
-(void)openDirectory:(Directory*)directory withCurrentView:(UIViewController *)current;
@end
