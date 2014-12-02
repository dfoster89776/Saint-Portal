//
//  SaintPortalAPI.h
//  Saint Portal
//
//  Created by David Foster on 28/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum {
    AuthenticationRequest = 1,
    UpdatePersonalDetailsRequest = 2,
    UpdateEnrolledModulesRequest = 3,
    UpdateModuleCourseworkRequest = 4,
    UpdateModuleEventsRequest = 5,
    UpdateModuleTopicsRequest = 6,
    UpdateTopicPostsRequest = 7,
    UpdateLocationsRequest = 8,
    RegisterDeviceForPushNotifications = 9
};

typedef NSUInteger SaintPortalAPIOperation;

@class SaintPortalAPI;

@protocol SaintPortalAPIDelegate

-(void)APICallbackHandler:(NSDictionary *)data;

@optional
-(void)APIErrorHandler:(NSError *)error;

@end

@interface SaintPortalAPI : NSObject
-(BOOL)APIRequest:(SaintPortalAPIOperation)APIOperation withDelegate:(id)delegate;
-(BOOL)APIRequest:(SaintPortalAPIOperation)APIOperation withData:(NSDictionary *)options withDelegate:(id)delegate;
@end
