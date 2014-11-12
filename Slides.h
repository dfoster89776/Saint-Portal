//
//  Slides.h
//  Saint Portal
//
//  Created by David Foster on 12/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "File.h"

@class Posts;

@interface Slides : File

@property (nonatomic, retain) Posts *slides_post;

@end
