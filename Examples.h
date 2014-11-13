//
//  Examples.h
//  Saint Portal
//
//  Created by David Foster on 13/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Directory.h"

@class Posts;

@interface Examples : Directory

@property (nonatomic, retain) NSNumber * example_id;
@property (nonatomic, retain) Posts *examples_post;

@end
