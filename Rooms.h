//
//  Rooms.h
//  Saint Portal
//
//  Created by David Foster on 11/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Buildings, Event, Staff;

@interface Rooms : NSManagedObject

@property (nonatomic, retain) NSNumber * location_id;
@property (nonatomic, retain) NSString * minor_value;
@property (nonatomic, retain) NSString * room_name;
@property (nonatomic, retain) Buildings *rooms_building;
@property (nonatomic, retain) NSSet *rooms_events;
@property (nonatomic, retain) Staff *rooms_staff;
@end

@interface Rooms (CoreDataGeneratedAccessors)

- (void)addRooms_eventsObject:(Event *)value;
- (void)removeRooms_eventsObject:(Event *)value;
- (void)addRooms_events:(NSSet *)values;
- (void)removeRooms_events:(NSSet *)values;

@end
