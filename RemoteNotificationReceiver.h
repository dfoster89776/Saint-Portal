//
//  RemoteNotificationReceiver.h
//  Saint Portal
//
//  Created by David Foster on 24/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface RemoteNotificationReceiver : NSObject

-(void)didReceiveNotification:(NSDictionary *)userInfo withHandler:(void (^)(UIBackgroundFetchResult))completionHandler isUserOpened:(BOOL)userOpened;

@end
