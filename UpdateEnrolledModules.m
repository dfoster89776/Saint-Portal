//
//  UpdateEnrolledModules.m
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "AppDelegate.h"
#import "UpdateEnrolledModules.h"
#import "SaintPortalAPI.h"
#import "Modules.h"

@interface UpdateEnrolledModules () <SaintPortalAPIDelegate>
@property (nonatomic) BOOL status;
@property (nonatomic, strong) id delegate;
@end

@implementation UpdateEnrolledModules

-(void)UpdateEnrolledModulesWithDelegate:(id)delegate{
    
    self.status = NO;
    
    self.delegate = delegate;
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    [api APIRequest:UpdateEnrolledModulesRequest withData:nil withDelegate:self];
    
}

-(void)APICallbackHandler:(NSDictionary *)data{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSMutableArray *module_list = [[NSMutableArray alloc] init];
    
    for (NSDictionary *module in data){
        
        [module_list addObject:[NSNumber numberWithInteger:[[module objectForKey:@"module_id"] integerValue]]];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Modules"];
        
        request.predicate = [NSPredicate predicateWithFormat:@"module_id = %@", [module objectForKey:@"module_id"]];
        
        NSError *error = nil;
        NSUInteger count = [context countForFetchRequest:request error:&error];
        
        Modules *new_module;
        
        if(count == 0){
                    
            new_module = [NSEntityDescription insertNewObjectForEntityForName:@"Modules"
                                                       inManagedObjectContext:context];
            new_module.module_code = [module objectForKey:@"module_code"];
            new_module.module_name = [module objectForKey:@"module_name"];
            new_module.module_id = [NSNumber numberWithInteger:[[module objectForKey:@"module_id"] integerValue]];
            new_module.current = [NSNumber numberWithInteger:[[module objectForKey:@"current"] integerValue]];
            new_module.year = [module objectForKey:@"year"];;
            new_module.semester = [module objectForKey:@"semester"];
            new_module.school = [module objectForKey:@"school"];
            
        }else if (count == 1){
            
            NSArray *details = [context executeFetchRequest:request error:&error];
            new_module = [details firstObject];
            
            new_module.module_code = [module objectForKey:@"module_code"];
            new_module.module_name = [module objectForKey:@"module_name"];
            new_module.module_id = [NSNumber numberWithInteger:[[module objectForKey:@"module_id"] integerValue]];
            new_module.current = [NSNumber numberWithInteger:[[module objectForKey:@"current"] integerValue]];
            new_module.year = [module objectForKey:@"year"];
            new_module.semester = [module objectForKey:@"semester"];
            new_module.school = [module objectForKey:@"school"];
        }
        
        NSError *saveError;
        [context save:&saveError];
    }
    
    
    
    NSArray *deletingModules = [NSArray arrayWithArray:module_list];
    NSError *deleteError;
    NSFetchRequest *deleteRequest = [NSFetchRequest fetchRequestWithEntityName:@"Modules"];
    deleteRequest.predicate = [NSPredicate predicateWithFormat:@"NOT (module_id IN %@)", deletingModules];
    NSArray *modulesToDelete = [context executeFetchRequest:deleteRequest error:&deleteError];
    
    for(Modules *deleteModule in modulesToDelete){
        
        [context deleteObject:deleteModule];
    }
    
 
    NSError *saveError;
    [context save:&saveError];
    
    self.status = YES;
    
    if(self.delegate != nil){
        [self.delegate moduleEnrollmentUpdateSuccess];
    }
    
    
    
}

-(void) APIErrorHandler:(NSError *)error{
    
    [self.delegate moduleEnrollmentUpdateFailure:error];
    
}

@end
