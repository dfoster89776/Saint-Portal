//
//  DirectoryUpdate.h
//  Saint Portal
//
//  Created by David Foster on 13/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Examples.h"
#import "Exercises.h"
#import "Directory.h"
#import "Coursework_Directory.h"

@interface DirectoryUpdate : NSObject

-(void)updateExamplesDirectory:(Examples *)example withData:(NSDictionary *)data;

-(void)updateExercisesDirectory:(Exercises *)exercise withData:(NSDictionary *)data;

-(void)updateCourseworkDirectory:(Coursework_Directory *)coursework withData:(NSDictionary *)data;

@end
