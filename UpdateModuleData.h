//
//  UpdateModuleData.h
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Modules.h"

@class UpdateModuleData;

@protocol UpdateModuleDataDelegate

-(void)moduleDataUpdateSuccess;
-(void)moduleDataUpdateFailure:(NSError*)error;

@end

@interface UpdateModuleData : NSObject

-(void)UpdateModuleDataForModule:(Modules *)module withDelegate:(id)delegate;

@end
