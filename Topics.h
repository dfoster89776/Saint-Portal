//
//  Topics.h
//  Saint Portal
//
//  Created by David Foster on 02/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Modules;

@interface Topics : NSManagedObject

@property (nonatomic, retain) NSNumber * topic_id;
@property (nonatomic, retain) NSString * topic_name;
@property (nonatomic, retain) NSString * topic_description;
@property (nonatomic, retain) NSNumber * topic_order;
@property (nonatomic, retain) Modules *topics_module;
@property (nonatomic, retain) NSSet *topics_posts;
@end

@interface Topics (CoreDataGeneratedAccessors)

- (void)addTopics_postsObject:(NSManagedObject *)value;
- (void)removeTopics_postsObject:(NSManagedObject *)value;
- (void)addTopics_posts:(NSSet *)values;
- (void)removeTopics_posts:(NSSet *)values;

@end
