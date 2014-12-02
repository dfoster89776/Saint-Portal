//
//  RemoteNotificationReceiver.m
//  Saint Portal
//
//  Created by David Foster on 24/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "RemoteNotificationReceiver.h"
#import "UpdateModuleCoursework.h"
#import "Modules.h"

@interface RemoteNotificationReceiver () <UpdateModuleCourseworkDelegate>
@property (nonatomic, copy) void (^completionHandler)(UIBackgroundFetchResult fetchResult);
@property (nonatomic, strong) NSManagedObjectContext* context;
@end

@implementation RemoteNotificationReceiver

-(void)didReceiveNotification:(NSDictionary *)userInfo withHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    self.completionHandler = completionHandler;
    
    UpdateModuleCoursework *umc = [[UpdateModuleCoursework alloc] init];
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Modules"];
    request.predicate = [NSPredicate predicateWithFormat:@"module_id = %@", [userInfo objectForKey:@"module"]];
    
    NSError *error = nil;
    
    NSArray *modules = [self.context executeFetchRequest:request error:&error];
    
    Modules* module = [modules firstObject];
    
    [umc updateCourseworkForModule:module withDelegate:self];
    
}

-(void)moduleCourseworkUpdateSuccess{
    
    self.completionHandler(UIBackgroundFetchResultNewData);
    
}

-(void)moduleCourseworkUpdateFailure:(NSError *)error{
    
    self.completionHandler(UIBackgroundFetchResultNewData);
    
}


@end
