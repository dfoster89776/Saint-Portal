//
//  Modules.h
//  Saint Portal
//
//  Created by David Foster on 08/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Coursework, Event, Module_Staff, Topics;

@interface Modules : NSManagedObject

@property (nonatomic, retain) NSNumber * current;
@property (nonatomic, retain) NSString * module_code;
@property (nonatomic, retain) NSString * module_description;
@property (nonatomic, retain) NSNumber * module_id;
@property (nonatomic, retain) NSString * module_name;
@property (nonatomic, retain) NSString * school;
@property (nonatomic, retain) NSString * semester;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSSet *module_assignments;
@property (nonatomic, retain) NSSet *module_events;
@property (nonatomic, retain) NSSet *modules_topics;
@property (nonatomic, retain) NSSet *staff;
@end

@interface Modules (CoreDataGeneratedAccessors)

- (void)addModule_assignmentsObject:(Coursework *)value;
- (void)removeModule_assignmentsObject:(Coursework *)value;
- (void)addModule_assignments:(NSSet *)values;
- (void)removeModule_assignments:(NSSet *)values;

- (void)addModule_eventsObject:(Event *)value;
- (void)removeModule_eventsObject:(Event *)value;
- (void)addModule_events:(NSSet *)values;
- (void)removeModule_events:(NSSet *)values;

- (void)addModules_topicsObject:(Topics *)value;
- (void)removeModules_topicsObject:(Topics *)value;
- (void)addModules_topics:(NSSet *)values;
- (void)removeModules_topics:(NSSet *)values;

- (void)addStaffObject:(Module_Staff *)value;
- (void)removeStaffObject:(Module_Staff *)value;
- (void)addStaff:(NSSet *)values;
- (void)removeStaff:(NSSet *)values;

@end
