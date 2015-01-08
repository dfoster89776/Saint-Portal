//
//  Staff.h
//  Saint Portal
//
//  Created by David Foster on 08/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module_Staff;

@interface Staff : NSManagedObject

@property (nonatomic, retain) NSNumber * staff_id;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phone_number;
@property (nonatomic, retain) NSSet *modules;
@end

@interface Staff (CoreDataGeneratedAccessors)

- (void)addModulesObject:(Module_Staff *)value;
- (void)removeModulesObject:(Module_Staff *)value;
- (void)addModules:(NSSet *)values;
- (void)removeModules:(NSSet *)values;

@end
