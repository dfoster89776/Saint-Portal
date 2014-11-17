//
//  Coursework_Directory.h
//  Saint Portal
//
//  Created by David Foster on 17/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Directory.h"

@class Coursework;

@interface Coursework_Directory : Directory

@property (nonatomic, retain) Coursework *directory_coursework;

@end
