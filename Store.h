//
//  Store.h
//  Saint Portal
//
//  Created by David Foster on 12/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Directory;

@interface Store : NSManagedObject

@property (nonatomic, retain) NSDate * last_update;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Directory *parent;

@end
