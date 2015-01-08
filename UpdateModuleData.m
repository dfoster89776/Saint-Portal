//
//  UpdateModuleData.m
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "UpdateModuleData.h"
#import "UpdateModuleCoursework.h"
#import "UpdateModuleTopics.h"
#import "UpdateModuleEvents.h"
#import "UpdateModuleStaff.h"

@interface UpdateModuleData () <UpdateModuleCourseworkDelegate, UpdateModuleTopicsDelegate, UpdateModuleEventsDelegate, UpdateModuleStaffDelegate>
@property (strong, nonatomic) Modules* module;
@property (strong, nonatomic) id delegate;

@property (strong, nonatomic) UpdateModuleCoursework* umc;
@property (strong, nonatomic) UpdateModuleTopics* umt;
@property (strong, nonatomic) UpdateModuleEvents* ume;
@property (strong, nonatomic) UpdateModuleStaff* ums;

@property BOOL umcStatus;
@property BOOL umtStatus;
@property BOOL umeStatus;
@property BOOL umsStatus;
@end

@implementation UpdateModuleData 

-(void)UpdateModuleDataForModule:(Modules *)module withDelegate:(id)delegate{
    
    self.module = module;
    self.delegate = delegate;
    
    self.umc = [[UpdateModuleCoursework alloc] init];
    [self.umc updateCourseworkForModule:self.module withDelegate:self];
    
    self.umt = [[UpdateModuleTopics alloc] init];
    [self.umt updateTopicsForModule:self.module withDelegate:self];
    
    self.ume = [[UpdateModuleEvents alloc] init];
    [self.ume updateEventsForModule:self.module withDelegate:self];
    
    self.ums = [[UpdateModuleStaff alloc] init];
    [self.ums updateStaffForModule:self.module withDelegate:self];
        
}

-(void)updateStatus{
    
    self.umcStatus = [self.umc getStatus];
    self.umtStatus = [self.umt getStatus];
    self.umeStatus = [self.ume getStatus];
    self.umsStatus = [self.ums getStatus];
    
    if(self.umcStatus && self.umtStatus && self.umeStatus && self.umsStatus){
        [self.delegate moduleDataUpdateSuccess];
    }
    
}

-(void)moduleCourseworkUpdateSuccess{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"courseworkUpdate" object:nil];
    [self updateStatus];
}

-(void)moduleCourseworkUpdateFailure:(NSError*)error{
    [self updateStatus];
}

-(void)moduleTopicsUpdateSuccess{
    
    [self updateStatus];
}

-(void)moduleTopicsUpdateFailure:(NSError*)error{
    [self updateStatus];
}

-(void)moduleEventsUpdateSuccess{
    
    [self updateStatus];
    
}

-(void)moduleEventsUpdateFailure:(NSError*)error{
    [self updateStatus];
}

-(void)moduleStaffUpdateSuccess{
    
    [self updateStatus];
}

-(void)moduleStaffUpdateFailure:(NSError *)error{
    
    [self updateStatus];
}
@end
