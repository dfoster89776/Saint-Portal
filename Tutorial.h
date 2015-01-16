//
//  Tutorial.h
//  Saint Portal
//
//  Created by David Foster on 15/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "File.h"

@class Posts;

@interface Tutorial : File

@property (nonatomic, retain) Posts *tutorial_post;

@end
