//
//  Buildings.h
//  Saint Portal
//
//  Created by David Foster on 06/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Rooms;

@interface Buildings : NSManagedObject

@property (nonatomic, retain) NSString * building_name;
@property (nonatomic, retain) NSString * major_value;
@property (nonatomic, retain) NSDecimalNumber * lattitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSSet *buildings_rooms;
@end

@interface Buildings (CoreDataGeneratedAccessors)

- (void)addBuildings_roomsObject:(Rooms *)value;
- (void)removeBuildings_roomsObject:(Rooms *)value;
- (void)addBuildings_rooms:(NSSet *)values;
- (void)removeBuildings_rooms:(NSSet *)values;

@end
