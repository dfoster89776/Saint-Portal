//
//  SetEventDetails.h
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
@class SetEventDetails;

@protocol SetEventDetailsDelegate

-(void)setEventDetailsSuccess;
-(void)setEventDetailsFailure:(NSError*)error;

@end

@interface SetEventDetails : NSObject
-(void)setDetailsForNewEvent:(Event *)event forModule:(Modules *)module withData:(NSDictionary *)data withDelegate:(id)delegate;
-(void)setDetailsForUpdateEvent:(Event *)event forModule:(Modules *)module withData:(NSDictionary *)data withDelegate:(id)delegate;
@end
