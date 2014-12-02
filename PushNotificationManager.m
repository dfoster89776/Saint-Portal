//
//  PushNotificationManager.m
//  Saint Portal
//
//  Created by David Foster on 20/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "PushNotificationManager.h"
#import "AppDelegate.h"
#import "SaintPortalAPI.h"

@interface PushNotificationManager () <SaintPortalAPIDelegate>

@end

@implementation PushNotificationManager

- (id)init {
    self = [super init];
    if (self) {
        
        [self registerForPushNotifications];
        
    }
    return self;
}

-(void)registerForPushNotifications{
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}

-(void)registerPushNotificationToken:(NSData *)token{
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:token forKey:@"apns_token"];
    
    SaintPortalAPI* api = [[SaintPortalAPI alloc] init];
    [api APIRequest:RegisterDeviceForPushNotifications withData:data withDelegate:self];
    
    NSLog(@"My token is: %@", token);
    
}

-(void)registerPushNotificationFailure{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Push Notifications Failed" message:@"Unfortunately, it was not possible to register your device for push notifications at this time, please try again later from the settings menu" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
}

-(void)APICallbackHandler:(NSDictionary *)data{
    
    
}

-(void)APIErrorHandler:(NSError *)error{
    
}


@end
