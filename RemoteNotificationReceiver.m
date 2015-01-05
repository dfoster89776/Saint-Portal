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
#import "Posts.h"
#import "Topics.h"

@interface RemoteNotificationReceiver () <UpdateCourseworkItemDelegate, UpdateTopicItemDelegate, UpdatePostItemDelegate>
@property (nonatomic, copy) void (^completionHandler)(UIBackgroundFetchResult fetchResult);
@property (nonatomic, strong) NSManagedObjectContext* context;
@property (nonatomic) BOOL userOpened;
@property (nonatomic, strong) NSNumber *item_id;
@end

@implementation RemoteNotificationReceiver

-(void)didReceiveNotification:(NSDictionary *)userInfo withHandler:(void (^)(UIBackgroundFetchResult))completionHandler isUserOpened:(BOOL)userOpened{
    
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
    
    [self.context save:&error];
    
    self.completionHandler(UIBackgroundFetchResultNewData);
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
    self.completionHandler(UIBackgroundFetchResultNewData);
    
}

-(void)courseworkItemUpdateFailure:(NSError *)error{
    self.completionHandler(UIBackgroundFetchResultNewData);
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
    
    [self.context save:&error];
    
    self.completionHandler(UIBackgroundFetchResultNewData);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"topicUpdate" object:nil];
    
}

-(void)topicItemUpdateSuccess{
    
    NSError *error;
    [self.context save:&error];
    
    if(self.userOpened){
        
        
        
    }
    
     NSLog(@"Update Topic Item Success");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"topicUpdate" object:nil];
    
    self.completionHandler(UIBackgroundFetchResultNewData);
    
}

-(void)topicItemUpdateFailure:(NSError *)error{
    
    [self.context save:&error];
    
    self.completionHandler(UIBackgroundFetchResultNewData);
    
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
    
    [self.context save:&error];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postUpdate" object:nil];
    self.completionHandler(UIBackgroundFetchResultNewData);
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
    
    self.completionHandler(UIBackgroundFetchResultNewData);
    
}

-(void)postItemUpdateFailure:(NSError *)error{
    
    self.completionHandler(UIBackgroundFetchResultNewData);
    
}

@end
