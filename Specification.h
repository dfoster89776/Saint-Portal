//
//  Specification.h
//  Saint Portal
//
//  Created by David Foster on 16/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "File.h"

@class Coursework;

@interface Specification : File

@property (nonatomic, retain) Coursework *coursework_item;

@end
