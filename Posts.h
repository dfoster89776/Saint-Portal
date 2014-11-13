//
//  Posts.h
//  Saint Portal
//
//  Created by David Foster on 13/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Examples, Slides, Topics;

@interface Posts : NSManagedObject

@property (nonatomic, retain) NSString * post_description;
@property (nonatomic, retain) NSNumber * post_id;
@property (nonatomic, retain) NSString * post_name;
@property (nonatomic, retain) NSNumber * post_order;
@property (nonatomic, retain) NSSet *posts_examples;
@property (nonatomic, retain) NSSet *posts_slides;
@property (nonatomic, retain) Topics *posts_topic;
@end

@interface Posts (CoreDataGeneratedAccessors)

- (void)addPosts_examplesObject:(Examples *)value;
- (void)removePosts_examplesObject:(Examples *)value;
- (void)addPosts_examples:(NSSet *)values;
- (void)removePosts_examples:(NSSet *)values;

- (void)addPosts_slidesObject:(Slides *)value;
- (void)removePosts_slidesObject:(Slides *)value;
- (void)addPosts_slides:(NSSet *)values;
- (void)removePosts_slides:(NSSet *)values;

@end
