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

@interface RemoteNotificationReceiver () <UpdateCourseworkItemDelegate>
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
    
    NSLog(@"UPDATING COURSEWORK NOTIFICATION");
    
    NSNumber* courseworkid = [[NSNumber alloc] initWithInt:[[userInfo objectForKey:@"courseworkid"] intValue]];
    self.item_id = courseworkid;
    
    UpdateCourseworkItem *uci = [[UpdateCourseworkItem alloc] init];
    [uci updateCourseworkItemWithID:courseworkid withDelegate:self];
    
}

-(void)newCourseworkNotificationWithData:(NSDictionary *)userInfo{

    NSLog(@"ADDING NEW COURSEWORK NOTIFICATION");
    
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


@end
