//
//  SetStaffLocation.m
//  Saint Portal
//
//  Created by David Foster on 11/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "SetStaffLocation.h"
#import "UpdateLocationsHandler.h"
#import "AppDelegate.h"
#import "Rooms.h"
#import "Staff.h"

@interface SetStaffLocation () <UpdateLocationsDelegate>
@property (nonatomic, strong)NSManagedObjectContext* context;
@property (nonatomic) int location_id;
@property (nonatomic, strong) Staff* staff;
@end

@implementation SetStaffLocation

-(void)setLocationForStaff:(Staff *)staff withLocationID:(int)location_id{
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.location_id = location_id;
    self.staff = staff;
    
    NSError* error;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Rooms"];
    request.predicate = [NSPredicate predicateWithFormat:@"location_id == %i", location_id];
    
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    
    if(count == 0){
        
        UpdateLocationsHandler *ulh = [[UpdateLocationsHandler alloc] init];
        [ulh updateLocationsLibraryWithDelegate:self];
        
    }else{
        
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        Rooms* location = [result firstObject];
        
        [self setStaffLocation:location];
    }
    
}


-(void)callback{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Rooms"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"location_id == %i", self.location_id];
    
    NSError *error = nil;
    
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    Rooms* location = [result firstObject];
    
    [self setStaffLocation:location];

    
}

-(void)setStaffLocation:(Rooms *)room{
    
    self.staff.office_location = room;
    
    NSError* error;
    
    [self.context save:&error];
    
    
}



@end
