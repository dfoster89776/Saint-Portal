//
//  UpdateModuleData.m
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "UpdateAllModuleData.h"
#import "UpdateEnrolledModules.h"
#import <CoreData/CoreData.h>
#import "Modules.h"
#import "AppDelegate.h"
#import "UpdateModuleData.h"

@interface UpdateAllModuleData () <UpdateEnrolledModulesDelegate, UpdateModuleDataDelegate>
@property (strong, nonatomic) id delegate;
@property (nonatomic) NSInteger moduleCount;
@property (nonatomic) NSInteger moduleReturns;
@end

@implementation UpdateAllModuleData

-(void)updateAllModuleDataWithDelegate:(id)delegate{
        
    self.delegate = delegate;
    
    UpdateEnrolledModules *uem = [[UpdateEnrolledModules alloc] init];
    [uem UpdateEnrolledModulesWithDelegate:self];

}


-(void)moduleEnrollmentUpdateSuccess{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Modules"];
    
    NSError *error = nil;
    
    NSArray *modules = [context executeFetchRequest:request error:&error];
    
    self.moduleCount = [modules count];
    self.moduleReturns = 0;
    
    for(Modules *module in modules){
        
        UpdateModuleData *umd = [[UpdateModuleData alloc] init];
        [umd UpdateModuleDataForModule:module withDelegate:self];
    
    }
    
    if(self.moduleCount == self.moduleReturns){
        [self.delegate updateAllModuleDataFailure:error];
    }
}


-(void)moduleEnrollmentUpdateFailure:(NSError*)error{
    if(self.delegate != nil){
    [self.delegate updateAllModuleDataFailure:error];
    }
}


-(void)moduleDataUpdateSuccess{
        
    self.moduleReturns++;
    
    if(self.moduleReturns == self.moduleCount){
        
        if(self.delegate != nil){
        
        [self.delegate updateAllModuleDataSuccess];
        }
    }
}

-(void)moduleDataUpdateFailure:(NSError *)error{
    
    self.moduleReturns++;
    
    if(self.moduleReturns == self.moduleCount){
        if(self.delegate != nil){
            [self.delegate updateAllModuleDataSuccess];
        }
    }
    
}

@end
