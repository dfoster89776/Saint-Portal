//
//  Buildings.h
//  Saint Portal
//
//  Created by David Foster on 06/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Buildings : NSManagedObject

@property (nonatomic, retain) NSString * building_name;
@property (nonatomic, retain) NSString * major_value;
@property (nonatomic, retain) NSSet *buildings_rooms;
@end

@interface Buildings (CoreDataGeneratedAccessors)

- (void)addBuildings_roomsObject:(NSManagedObject *)value;
- (void)removeBuildings_roomsObject:(NSManagedObject *)value;
- (void)addBuildings_rooms:(NSSet *)values;
- (void)removeBuildings_rooms:(NSSet *)values;

@end
