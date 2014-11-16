//
//  Coursework.h
//  Saint Portal
//
//  Created by David Foster on 16/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Modules, Specification;

@interface Coursework : NSManagedObject

@property (nonatomic, retain) NSString * coursework_description;
@property (nonatomic, retain) NSDate * coursework_due;
@property (nonatomic, retain) NSDate * coursework_feedback_date;
@property (nonatomic, retain) NSNumber * coursework_id;
@property (nonatomic, retain) NSString * coursework_name;
@property (nonatomic, retain) NSNumber * coursework_weighting;
@property (nonatomic, retain) NSNumber * submitted;
@property (nonatomic, retain) Modules *assignments_module;
@property (nonatomic, retain) Specification *specification;

@end
