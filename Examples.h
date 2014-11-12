//
//  Examples.h
//  Saint Portal
//
//  Created by David Foster on 12/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Store.h"

@class Posts;

@interface Examples : Store

@property (nonatomic, retain) Posts *examples_post;

@end
