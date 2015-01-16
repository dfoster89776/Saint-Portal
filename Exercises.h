//
//  Exercises.h
//  Saint Portal
//
//  Created by David Foster on 15/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Directory.h"

@class Posts;

@interface Exercises : Directory

@property (nonatomic, retain) NSNumber * exercise_id;
@property (nonatomic, retain) Posts *exercises_post;

@end
