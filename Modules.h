//
//  Modules.h
//  Saint Portal
//
//  Created by David Foster on 30/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Coursework, Event, Topics;

@interface Modules : NSManagedObject

@property (nonatomic, retain) NSNumber * current;
@property (nonatomic, retain) NSString * module_code;
@property (nonatomic, retain) NSNumber * module_id;
@property (nonatomic, retain) NSString * module_name;
@property (nonatomic, retain) NSString * school;
@property (nonatomic, retain) NSString * semester;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSString * module_description;
@property (nonatomic, retain) NSSet *module_assignments;
@property (nonatomic, retain) NSSet *module_events;
@property (nonatomic, retain) NSSet *modules_topics;
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

@end
