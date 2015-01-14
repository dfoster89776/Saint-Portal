//
//  RemoteNotificationReceiver.m
//  Saint Portal
//
//  Created by David Foster on 24/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "RemoteNotificationReceiver.h"
#import "UpdateModuleCoursework.h"
#import "UpdateCourseworkItem.h"
#import "Modules.h"
#import "Coursework.h"
#import "UpdateTopicItem.h"
#import "UpdatePostItem.h"
#import "UpdateEventItem.h"
#import "Posts.h"
#import "Topics.h"
#import "Notification.h"
#import "UpdateNotificationsListHandler.h"

@interface RemoteNotificationReceiver () <UpdateCourseworkItemDelegate, UpdateTopicItemDelegate, UpdatePostItemDelegate, UpdateNotificationsDelegate, UpdateEventItemDelegate>
@property (nonatomic, copy) void (^completionHandler)(UIBackgroundFetchResult fetchResult);
@property (nonatomic, strong) NSManagedObjectContext* context;
@property (nonatomic) BOOL userOpened;
@property (nonatomic, strong) NSNumber *item_id;
@property (nonatomic) BOOL dataUpdate;
@property (nonatomic) BOOL notificationUpdate;
@end

@implementation RemoteNotificationReceiver

-(void)didReceiveNotification:(NSDictionary *)userInfo withHandler:(void (^)(UIBackgroundFetchResult))completionHandler isUserOpened:(BOOL)userOpened{
    
    self.dataUpdate = false;
    self.notificationUpdate = false;
    
    NSLog(@"%@", userInfo);
    
    NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    [self createNotificationWithMessage:message];
    
    self.userOpened = userOpened;
    self.completionHandler = completionHandler;
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    if([[userInfo objectForKey:@"type"] isEqualToString:@"deleted_coursework"]){
        [self deleteCourseworkNotificationWithData:userInfo];
    }
    else if([[userInfo objectForKey:@"type"] isEqualToString:@"update_coursework"]){
        [self updateCourseworkNotificationWithData:userInfo];
    }
    else if([[userInfo objectForKey:@"type"] isEqualToString:@"new_coursework"]){
        [self newCourseworkNotificationWithData:userInfo];
    }
    else if([[userInfo objectForKey:@"type"] isEqualToString:@"coursework_feedback"]){
        [self updateCourseworkNotificationWithData:userInfo];
    }
    else if([[userInfo objectForKey:@"type"] isEqualToString:@"new_topic"]){
        [self newTopicNotificationWithData:userInfo];
    }
    else if([[userInfo objectForKey:@"type"] isEqualToString:@"updated_topic"]){
        [self updateTopicNotificationWithData:userInfo];
    }
    else if([[userInfo objectForKey:@"type"] isEqualToString:@"deleted_topic"]){
        [self deleteTopicNotificationWithData:userInfo];
    }
    else if([[userInfo objectForKey:@"type"] isEqualToString:@"new_post"]){
        [self newPostNotificationWithData:userInfo];
    }
    else if([[userInfo objectForKey:@"type"] isEqualToString:@"updated_post"]){
        [self updatePostNotificationWithData:userInfo];
    }
    else if([[userInfo objectForKey:@"type"] isEqualToString:@"deleted_post"]){
        [self deletePostNotificationWithData:userInfo];
    }
    else if([[userInfo objectForKey:@"type"] isEqualToString:@"new_event"]){
        [self newEventNotificationWithData:userInfo];
    }
    else if([[userInfo objectForKey:@"type"] isEqualToString:@"updated_event"]){
        [self updateEventNotificationWithData:userInfo];
    }
    else if ([[userInfo objectForKey:@"type"] isEqualToString:@"deleted_event"]){
        [self deleteEventNotificationWithData:userInfo];
    }
}

-(void)deleteCourseworkNotificationWithData:(NSDictionary *)userInfo{
        
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coursework"];
    request.predicate = [NSPredicate predicateWithFormat:@"coursework_id = %@", [userInfo objectForKey:@"courseworkid"]];
    
    NSError *error = nil;
    
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    if(count == 1) {
        //Handle error
        
        NSArray* result = [self.context executeFetchRequest:request error:&error];
        
        [self.context deleteObject:[result firstObject]];
        
    }
    
    self.dataUpdate = true;
    
    if(self.notificationUpdate){
        self.completionHandler(UIBackgroundFetchResultNewData);
        [self.context save:&error];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"courseworkUpdate" object:nil];
}

-(void)updateCourseworkNotificationWithData:(NSDictionary *)userInfo{
    
    NSNumber* courseworkid = [[NSNumber alloc] initWithInt:[[userInfo objectForKey:@"courseworkid"] intValue]];
    self.item_id = courseworkid;
    
    UpdateCourseworkItem *uci = [[UpdateCourseworkItem alloc] init];
    [uci updateCourseworkItemWithID:courseworkid withDelegate:self];
    
}

-(void)newCourseworkNotificationWithData:(NSDictionary *)userInfo{
    
    NSNumber* courseworkid = [[NSNumber alloc] initWithInt:[[userInfo objectForKey:@"courseworkid"] intValue]];
    self.item_id = courseworkid;
    
    UpdateCourseworkItem *uci = [[UpdateCourseworkItem alloc] init];
    [uci updateCourseworkItemWithID:courseworkid withDelegate:self];
    
}

-(void)courseworkItemUpdateSuccess{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"courseworkUpdate" object:nil];
    
    if(self.userOpened){
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] displayCourseworkItemWithId:self.item_id];
        
    }
    
    self.dataUpdate = true;
    
    if(self.notificationUpdate){
        self.completionHandler(UIBackgroundFetchResultNewData);
        NSError *error;
        [self.context save:&error];
    }
    
}

-(void)courseworkItemUpdateFailure:(NSError *)error{
    self.dataUpdate = true;
    
    if(self.notificationUpdate){
        self.completionHandler(UIBackgroundFetchResultNewData);
        [self.context save:&error];
    }
}

-(void)newTopicNotificationWithData:(NSDictionary *)userInfo{
    
    NSNumber* topicid = [[NSNumber alloc] initWithInt:[[userInfo objectForKey:@"topicid"] intValue]];
    self.item_id = topicid;
    
    UpdateTopicItem *uti = [[UpdateTopicItem alloc] init];
    [uti updateTopicItemWithID:topicid withDelegate:self];
    
}

-(void)updateTopicNotificationWithData:(NSDictionary *)userInfo{
    
    NSNumber* topicid = [[NSNumber alloc] initWithInt:[[userInfo objectForKey:@"topicid"] intValue]];
    self.item_id = topicid;
    
    UpdateTopicItem *uti = [[UpdateTopicItem alloc] init];
    [uti updateTopicItemWithID:topicid withDelegate:self];
    
}

-(void)deleteTopicNotificationWithData:(NSDictionary *)userInfo{
    
    NSError *error = nil;

    
    NSFetchRequest *allRequest = [NSFetchRequest fetchRequestWithEntityName:@"Topics"];
    NSArray *allResults = [self.context executeFetchRequest:allRequest error:&error];
    
    for(Topics *topic in allResults){
        NSLog(@"Topic with id: %@", topic.topic_id);
    }
    
    NSLog(@"%@", userInfo);
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Topics"];
    request.predicate = [NSPredicate predicateWithFormat:@"topic_id = %@", [userInfo objectForKey:@"topicid"]];
    
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    if(count >= 1) {
        //Handle error
        
        NSArray* result = [self.context executeFetchRequest:request error:&error];
        
        for(Topics* topic in result){
         
            [self.context deleteObject:topic];
        }
        
        NSLog(@"Deleteing topic");
        
    }
    
    self.dataUpdate = true;
    
    if(self.notificationUpdate){
        self.completionHandler(UIBackgroundFetchResultNewData);
        [self.context save:&error];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"topicUpdate" object:nil];
    
}

-(void)topicItemUpdateSuccess{
    
    if(self.userOpened){
        
        
        
    }
    
     NSLog(@"Update Topic Item Success");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"topicUpdate" object:nil];
    
    self.dataUpdate = true;
    
    NSError *error;
    if(self.notificationUpdate){
        self.completionHandler(UIBackgroundFetchResultNewData);
        [self.context save:&error];
    }
    
}

-(void)topicItemUpdateFailure:(NSError *)error{
    
    self.dataUpdate = true;
    
    if(self.notificationUpdate){
        self.completionHandler(UIBackgroundFetchResultNewData);
        [self.context save:&error];
    }
    
}

-(void)deletePostNotificationWithData:(NSDictionary *)userInfo{
    
    NSLog(@"%@", userInfo);
    
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Posts"];
    request.predicate = [NSPredicate predicateWithFormat:@"post_id = %@", [userInfo objectForKey:@"postid"]];
    
    NSError *error = nil;
    
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    
    NSLog(@"%@", error.userInfo);
    
    if(count == 1) {
        //Handle error
        
        NSArray* result = [self.context executeFetchRequest:request error:&error];
        
        [self.context deleteObject:[result firstObject]];
        NSLog(@"DELETING POST");
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postUpdate" object:nil];
    self.dataUpdate = true;
    
    if(self.notificationUpdate){
        self.completionHandler(UIBackgroundFetchResultNewData);
        [self.context save:&error];
    }
}

-(void)newPostNotificationWithData:(NSDictionary *)userInfo{
    
    NSNumber* postid = [[NSNumber alloc] initWithInt:[[userInfo objectForKey:@"postid"] intValue]];
    self.item_id = postid;
    
    UpdatePostItem *upi = [[UpdatePostItem alloc] init];
    [upi updatePostItemWithID:postid withDelegate:self];
    
}

-(void)updatePostNotificationWithData:(NSDictionary *)userInfo{
    
    NSNumber* postid = [[NSNumber alloc] initWithInt:[[userInfo objectForKey:@"postid"] intValue]];
    self.item_id = postid;
    
    UpdatePostItem *upi = [[UpdatePostItem alloc] init];
    [upi updatePostItemWithID:postid withDelegate:self];
    
}

-(void)postItemUpdateSuccess{
    
    NSLog(@"Update Post Item Success");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postUpdate" object:nil];
    
    if(self.userOpened){
        
        
        
    }
    
    self.dataUpdate = true;
    
    if(self.notificationUpdate){
        self.completionHandler(UIBackgroundFetchResultNewData);
        NSError *error;
        [self.context save:&error];
    }
    
}

-(void)postItemUpdateFailure:(NSError *)error{
    
    self.dataUpdate = true;
    
    if(self.notificationUpdate){
        self.completionHandler(UIBackgroundFetchResultNewData);
        [self.context save:&error];
    }
    
}

-(void)deleteEventNotificationWithData:(NSDictionary *)userInfo{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    request.predicate = [NSPredicate predicateWithFormat:@"event_id = %@", [userInfo objectForKey:@"eventid"]];
    
    NSError *error = nil;
    
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    if(count == 1) {
        //Handle error
        
        NSArray* result = [self.context executeFetchRequest:request error:&error];
        
        [self.context deleteObject:[result firstObject]];
        
    }
    
    self.dataUpdate = true;
    
    if(self.notificationUpdate){
        self.completionHandler(UIBackgroundFetchResultNewData);
        [self.context save:&error];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"eventUpdate" object:nil];
}

-(void)newEventNotificationWithData:(NSDictionary *)userInfo{
    
    NSNumber* eventid = [[NSNumber alloc] initWithInt:[[userInfo objectForKey:@"eventid"] intValue]];
    self.item_id = eventid;
    
    UpdateEventItem *uei = [[UpdateEventItem alloc] init];
    [uei updateEventItemWithID:eventid withDelegate:self];
    
}

-(void)updateEventNotificationWithData:(NSDictionary *)userInfo{
    
    NSNumber* eventid = [[NSNumber alloc] initWithInt:[[userInfo objectForKey:@"eventid"] intValue]];
    self.item_id = eventid;
    
    UpdateEventItem *uei = [[UpdateEventItem alloc] init];
    [uei updateEventItemWithID:eventid withDelegate:self];
    
}

-(void)eventItemUpdateSuccess{
    
    NSLog(@"Update Post Item Success");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"eventUpdate" object:nil];
    
    if(self.userOpened){
        
        
        
    }
    
    self.dataUpdate = true;
    
    if(self.notificationUpdate){
        self.completionHandler(UIBackgroundFetchResultNewData);
        NSError *error;
        [self.context save:&error];
    }
    
}

-(void)eventItemUpdateFailure:(NSError *)error{
    
    self.dataUpdate = true;
    
    if(self.notificationUpdate){
        self.completionHandler(UIBackgroundFetchResultNewData);
        [self.context save:&error];
    }
    
}

-(void)createNotificationWithMessage:(NSString *)message{
    
    NSLog(@"Updating notifications list");
    
    UpdateNotificationsListHandler *unlh = [[UpdateNotificationsListHandler alloc] init];
    [unlh updateNotificationsWithDelegate:self];

}

-(void)notificationsUpdateSuccess{
    
    self.notificationUpdate = true;
    
    if(self.dataUpdate){
        
        self.completionHandler(UIBackgroundFetchResultNewData);
        NSError *error;
        [self.context save:&error];

    }
    
}

-(void)notificationsUpdateFailure:(NSError *)error{
    
    self.notificationUpdate = true;
    
    if(self.dataUpdate){
        
        self.completionHandler(UIBackgroundFetchResultNewData);
        [self.context save:&error];

    }
    
}


@end
