//
//  UpdateNotificationsListHandler.h
//  Saint Portal
//
//  Created by David Foster on 11/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UpdateNotificationsListHandler;

@protocol UpdateNotificationsDelegate

-(void)notificationsUpdateSuccess;
-(void)notificationsUpdateFailure:(NSError *)error;
@end


@interface UpdateNotificationsListHandler : NSObject

-(void)updateNotificationsWithDelegate:(id)delegate;

@end