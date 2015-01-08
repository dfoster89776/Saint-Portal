//
//  Module_Staff.h
//  Saint Portal
//
//  Created by David Foster on 08/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Modules, Staff;

@interface Module_Staff : NSManagedObject

@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) Modules *module;
@property (nonatomic, retain) Staff *staff;

@end
