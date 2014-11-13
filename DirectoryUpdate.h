//
//  DirectoryUpdate.h
//  Saint Portal
//
//  Created by David Foster on 13/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Examples.h"
#import "Directory.h"

@interface DirectoryUpdate : NSObject

-(void)updateExamplesDirectory:(Examples *)example withData:(NSDictionary *)data;

@end
