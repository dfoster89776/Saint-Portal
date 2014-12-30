//
//  Submission.h
//  Saint Portal
//
//  Created by David Foster on 30/12/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "File.h"

@class Coursework;

@interface Submission : File

@property (nonatomic, retain) NSDate * submission_time;
@property (nonatomic, retain) Coursework *coursework_item;

@end
