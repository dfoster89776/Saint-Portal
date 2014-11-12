//
//  UpdateModuleTopics.h
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Modules.h"

@class UpdateModuleTopics;

@protocol UpdateModuleTopicsDelegate

-(void)moduleTopicsUpdateSuccess;
-(void)moduleTopicsUpdateFailure:(NSError*)error;

@end

@interface UpdateModuleTopics : NSObject

-(void)updateTopicsForModule:(Modules *)module withDelegate:(id)delegate;
-(BOOL)getStatus;

@end
