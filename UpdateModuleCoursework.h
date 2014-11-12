//
//  UpdateModuleCoursework.h
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Modules.h"

@class UpdateModuleCoursework;

@protocol UpdateModuleCourseworkDelegate

-(void)moduleCourseworkUpdateSuccess;
-(void)moduleCourseworkUpdateFailure:(NSError*)error;

@end

@interface UpdateModuleCoursework : NSObject

-(void)updateCourseworkForModule:(Modules *)module withDelegate:(id)delegate;
-(BOOL)getStatus;

@end
