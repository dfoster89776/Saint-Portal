//
//  Feedback.h
//  Saint Portal
//
//  Created by David Foster on 21/12/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Coursework;

@interface Feedback : NSManagedObject

@property (nonatomic, retain) NSNumber * grade;
@property (nonatomic, retain) NSDate * received;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) Coursework *coursework_item;

@end
