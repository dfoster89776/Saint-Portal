//
//  UpdateNotificationsListHandler.m
//  Saint Portal
//
//  Created by David Foster on 11/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "UpdateNotificationsListHandler.h"
#import "AppDelegate.h"
#import "SaintPortalAPI.h"
#import "Notification.h"

@interface UpdateNotificationsListHandler () <SaintPortalAPIDelegate>
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSManagedObjectContext* context;
@end

@implementation UpdateNotificationsListHandler

-(void)updateNotificationsWithDelegate:(id)delegate{
        
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.delegate = delegate;
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    NSNumber *lastNotificationReceived = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_notification"];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:lastNotificationReceived forKey:@"last_notification"];
    
    [api APIRequest:UpdateNotificationsList withData:data withDelegate:self];
    
    
}

-(void)APICallbackHandler:(NSDictionary *)data{
    
    if([[data objectForKey:@"new_notifications_available"] boolValue]){
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSArray *new_notifications = [data objectForKey:@"notifications_data"];
        
        for(NSDictionary* notification in new_notifications){
            
            Notification* new_notification = [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:self.context];
            
            new_notification.message = [notification objectForKey:@"message"];
            
            
            new_notification.received = [df dateFromString:[notification objectForKey:@"timestamp"]];
            
            if([notification objectForKey:@"type"] != [NSNull null]){
                new_notification.type = [notification objectForKey:@"type"];
                new_notification.linked_id = [NSNumber numberWithInteger:[[notification objectForKey:@"item_id"] integerValue]];
            }
            
            int notification_id = [[notification objectForKey:@"notification_id"] intValue];
            int previous_notification = [[[NSUserDefaults standardUserDefaults] objectForKey:@"last_notification"] intValue];

            if(notification_id > previous_notification){
                
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:notification_id] forKey:@"last_notification"];
                
            }
            
        }
        
        if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
            
            NSNumber *badge_count = [[NSUserDefaults standardUserDefaults] objectForKey:@"badge_count"];
            
            int add = (int)[new_notifications count];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:([badge_count intValue] + add)] forKey:@"badge_count"];
            
            [(AppDelegate*) [[UIApplication sharedApplication] delegate] updateBadge];
        }
    }
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsUpdate" object:nil];
    
    if(self.delegate != nil){
        [self.delegate notificationsUpdateSuccess];
    }
    
    
}

-(void)APIErrorHandler:(NSError *)error{
    
    if(self.delegate != nil){
        [self.delegate notificationsUpdateFailure:error];
    }
    
}

@end
