//
//  UpdateLocationsHandler.h
//  Saint Portal
//
//  Created by David Foster on 06/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class UpdateLocationsHandler;
@protocol UpdateLocationsDelegate

-(void)callback;

@optional
-(void)APIErrorHandler:(NSError *)error;
@end

@interface UpdateLocationsHandler : NSObject

-(void)updateLocationsLibraryWithDelegate:(id)delegate;
-(void)updateLocationsLibrary;

@end
