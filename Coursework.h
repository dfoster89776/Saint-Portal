//
//  Coursework.h
//  Saint Portal
//
//  Created by David Foster on 02/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Modules;

@interface Coursework : NSManagedObject

@property (nonatomic, retain) NSDate * coursework_due;
@property (nonatomic, retain) NSNumber * coursework_id;
@property (nonatomic, retain) NSString * coursework_name;
@property (nonatomic, retain) NSDate * coursework_feedback_date;
@property (nonatomic, retain) NSNumber * coursework_weighting;
@property (nonatomic, retain) NSString * coursework_file;
@property (nonatomic, retain) NSNumber * submitted;
@property (nonatomic, retain) NSString * coursework_description;
@property (nonatomic, retain) Modules *assignments_module;

@end
