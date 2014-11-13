//
//  File.h
//  Saint Portal
//
//  Created by David Foster on 13/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Directory;

@interface File : NSManagedObject

@property (nonatomic, retain) NSNumber * file_id;
@property (nonatomic, retain) NSString * file_url;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Directory *parentDirectory;

@end
