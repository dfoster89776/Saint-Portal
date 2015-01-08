//
//  UpdateModuleStaff.h
//  Saint Portal
//
//  Created by David Foster on 08/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Modules.h"

@class UpdateModuleStaff;

@protocol UpdateModuleStaffDelegate

-(void)moduleStaffUpdateSuccess;
-(void)moduleStaffUpdateFailure:(NSError*)error;

@end

@interface UpdateModuleStaff : NSObject

-(void)updateStaffForModule:(Modules *)module withDelegate:(id)delegate;
-(BOOL)getStatus;

@end