//
//  Directory.h
//  Saint Portal
//
//  Created by David Foster on 12/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Store.h"

@class Store;

@interface Directory : Store

@property (nonatomic, retain) NSNumber * directory_id;
@property (nonatomic, retain) NSSet *children;
@end

@interface Directory (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Store *)value;
- (void)removeChildrenObject:(Store *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
