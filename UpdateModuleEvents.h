//
//  UpdateModuleEvents.h
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Modules.h"

@class UpdateModuleEvents;

@protocol UpdateModuleEventsDelegate

-(void)moduleEventsUpdateSuccess;
-(void)moduleEventsUpdateFailure:(NSError*)error;

@end

@interface UpdateModuleEvents : NSObject

-(void)updateEventsForModule:(Modules *)module withDelegate:(id)delegate;
-(BOOL)getStatus;

@end
