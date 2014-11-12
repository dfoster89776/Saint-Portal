//
//  UpdateLocationsHandler.m
//  Saint Portal
//
//  Created by David Foster on 06/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "UpdateLocationsHandler.h"
#import "SaintPortalAPI.h"
#import "AppDelegate.h"
#import "Buildings.h"
#import "Rooms.h"

@interface UpdateLocationsHandler ()

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation UpdateLocationsHandler

-(void)updateLocationsLibraryWithDelegate:(id)delegate{
    
    self.delegate = delegate;
    [self updateLocationsLibrary];
    
}

-(void)updateLocationsLibrary{
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    [api APIRequest:UpdateLocationsRequest withDelegate:self];
    
}


-(void)APICallbackHandler:(NSDictionary *)data{
        
    NSMutableArray *building_list = [[NSMutableArray alloc] init];
    
    //Check that all buildings are in core data
    
    if([[data valueForKey:@"buildings_exist"] boolValue]){
        
        //For each building in list
        for (NSDictionary *building in [data valueForKey:@"buildings_details"]){
            
            [building_list addObject:[building objectForKey:@"building_name"]];
            
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Buildings"];
            
            request.predicate = [NSPredicate predicateWithFormat:@"building_name == %@", [building objectForKey:@"building_name"]];
            
            NSError *error = nil;
            NSUInteger count = [self.context countForFetchRequest:request error:&error];
            
            Buildings *newBuilding;
            
            //If count is zero, add building
            if(count == 0){
                
                newBuilding = [NSEntityDescription insertNewObjectForEntityForName:@"Buildings"
                                                           inManagedObjectContext:self.context];
                
                newBuilding.building_name = [building objectForKey:@"building_name"];
                newBuilding.major_value = [building objectForKey:@"major_id"];
            }
            
            //Else update building
            else{
                
                NSArray *result = [self.context executeFetchRequest:request error:&error];
                newBuilding = [result firstObject];
                
                newBuilding.building_name = [building objectForKey:@"building_name"];
                newBuilding.major_value = [building objectForKey:@"major_id"];
            }
            
            for(NSDictionary *room in [building objectForKey:@"rooms"]){
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"location_id == %i", [[room objectForKey:@"location_id"] integerValue]];
                
                NSSet *matches = [newBuilding.buildings_rooms filteredSetUsingPredicate:predicate];
                
                Rooms *newRoom;
                
                if([matches count] == 0){
                    
                    newRoom = [NSEntityDescription insertNewObjectForEntityForName:@"Rooms" inManagedObjectContext:self.context];
                    
                    newRoom.location_id = [NSNumber numberWithInteger:[[room objectForKey:@"location_id"] integerValue]];
                    newRoom.room_name = [room objectForKey:@"room_name"];
                    newRoom.rooms_building = newBuilding;
                    newRoom.minor_value = [room objectForKey:@"minor"];
                    
                    [newBuilding addBuildings_roomsObject:newRoom];
                    
                }else{
                    
                    newRoom = [[matches allObjects] firstObject];
                    
                   
                    
                    newRoom.location_id = [NSNumber numberWithInteger:[[room objectForKey:@"location_id"] integerValue]];
                    newRoom.room_name = [room objectForKey:@"room_name"];
                    newRoom.rooms_building = newBuilding;
                    newRoom.minor_value = [room objectForKey:@"minor"];
                    
                }
            }
            
        }
    }
    

    NSError *error;
    [self.context save:&error];
    
    [self.delegate callback];
    
}

-(void)APIErrorHandler:(NSError *)error{
    
    
}

@end
