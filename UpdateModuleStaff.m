//
//  UpdateModuleStaff.m
//  Saint Portal
//
//  Created by David Foster on 08/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "UpdateModuleStaff.h"
#import "SaintPortalAPI.h"
#import "AppDelegate.h"
#import "Staff.h"
#import "Module_Staff.h"
#import "SetStaffLocation.h"

@interface UpdateModuleStaff () <SaintPortalAPIDelegate>
@property (nonatomic, strong)Modules *module;
@property (nonatomic, strong)NSManagedObjectContext *context;
@property (nonatomic, strong)id delegate;
@property BOOL status;
@property (nonatomic) int location_id;
@end

@implementation UpdateModuleStaff

-(void)updateStaffForModule:(Modules *)module withDelegate:(id)delegate{
 
    self.module = module;
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.delegate = delegate;
    self.status = false;
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:self.module.module_id forKey:@"module_id"];
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    [api APIRequest:UpdateModuleStaffRequest withData:data withDelegate:self];
    
}

-(void)APICallbackHandler:(NSDictionary *)data{
    
    if([[data valueForKey:@"staff_exist"] boolValue]){
        
        for (NSDictionary *staffDetails in [data valueForKey:@"staff_details"]){
    
            Staff *staff = [self getStaffWithData:staffDetails];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"staff == %@", staff];
            
            NSSet *matches = [self.module.staff filteredSetUsingPredicate:predicate];
            
            if([matches count] == 0){
                
                Module_Staff *module_staff = [NSEntityDescription insertNewObjectForEntityForName:@"Module_Staff" inManagedObjectContext:self.context];
                module_staff.module = self.module;
                module_staff.staff = staff;
                module_staff.role = [staffDetails objectForKey:@"role"];
                
            }else{
                
                Module_Staff *module_staff = [[matches allObjects] firstObject];
                module_staff.role = [staffDetails objectForKey:@"role"];
            }
        }
    }
    
    self.status = true;
    
    NSError *error;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
    [self.delegate moduleStaffUpdateSuccess];
    
}

-(void) APIErrorHandler:(NSError *)error{
    
    self.status = true;
    
    [self.delegate moduleStaffUpdateFailure:error];
    
}

-(BOOL)getStatus{
    
    return self.status;
    
}

-(Staff*)getStaffWithData:(NSDictionary*)data{
    
    Staff* staff = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Staff"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"staff_id == %i", [[data objectForKey:@"staff_id"] integerValue]];
    
    NSError *error = nil;
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    
    if(count == 0){
        
        //Add staff member
        staff = [NSEntityDescription insertNewObjectForEntityForName:@"Staff"
                                                   inManagedObjectContext:self.context];
        
        staff.staff_id = [NSNumber numberWithInteger:[[data objectForKey:@"staff_id"] integerValue]];
        staff.firstname = [data objectForKey:@"firstname"];
        staff.surname = [data objectForKey:@"surname"];
        staff.phone_number = [data objectForKey:@"phone_number"];
        staff.email = [data objectForKey:@"email"];
        
        
        
        
    }else{
        
        //Update staff member
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        staff.firstname = [data objectForKey:@"firstname"];
        staff.surname = [data objectForKey:@"surname"];
        staff.phone_number = [data objectForKey:@"phone_number"];
        staff.email = [data objectForKey:@"email"];
        staff = [result firstObject];
        
    }
    
    if([data objectForKey:@"location"]){
        int location_id = [[data objectForKey:@"location"] intValue];
    
        SetStaffLocation* ssl = [[SetStaffLocation alloc] init];
        [ssl setLocationForStaff:staff withLocationID:location_id];

    }
    
        
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
    //Return staff member
    return staff;
    
}

@end
