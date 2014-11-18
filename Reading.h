//
//  Reading.h
//  Saint Portal
//
//  Created by David Foster on 17/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Posts;

@interface Reading : NSManagedObject

@property (nonatomic, retain) NSNumber * reading_id;
@property (nonatomic, retain) Posts *readings_post;

@end
