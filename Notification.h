//
//  Notification.h
//  Saint Portal
//
//  Created by David Foster on 11/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notification : NSManagedObject

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSDate * received;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * linked_id;

@end
