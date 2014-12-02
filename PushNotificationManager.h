//
//  PushNotificationManager.h
//  Saint Portal
//
//  Created by David Foster on 20/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushNotificationManager : NSObject

-(void)registerPushNotificationToken:(NSData *)token;

-(void)registerPushNotificationFailure;

@end
