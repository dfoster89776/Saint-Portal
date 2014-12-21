//
//  Coursework.h
//  Saint Portal
//
//  Created by David Foster on 21/12/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Coursework_Directory, Modules, Specification, Feedback;

@interface Coursework : NSManagedObject

@property (nonatomic, retain) NSString * coursework_description;
@property (nonatomic, retain) NSDate * coursework_due;
@property (nonatomic, retain) NSDate * coursework_feedback_date;
@property (nonatomic, retain) NSNumber * coursework_id;
@property (nonatomic, retain) NSString * coursework_name;
@property (nonatomic, retain) NSNumber * coursework_weighting;
@property (nonatomic, retain) NSNumber * submitted;
@property (nonatomic, retain) NSNumber * feedback_received;
@property (nonatomic, retain) Modules *assignments_module;
@property (nonatomic, retain) Coursework_Directory *coursework_directory;
@property (nonatomic, retain) Specification *specification;
@property (nonatomic, retain) Feedback *feedback;

@end
