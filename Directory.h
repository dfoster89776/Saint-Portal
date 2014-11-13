//
//  Directory.h
//  Saint Portal
//
//  Created by David Foster on 13/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Directory, File;

@interface Directory : NSManagedObject

@property (nonatomic, retain) NSNumber * directory_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *files;
@property (nonatomic, retain) Directory *parent_directory;
@property (nonatomic, retain) NSSet *child_directories;
@end

@interface Directory (CoreDataGeneratedAccessors)

- (void)addFilesObject:(File *)value;
- (void)removeFilesObject:(File *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;

- (void)addChild_directoriesObject:(Directory *)value;
- (void)removeChild_directoriesObject:(Directory *)value;
- (void)addChild_directories:(NSSet *)values;
- (void)removeChild_directories:(NSSet *)values;

@end
