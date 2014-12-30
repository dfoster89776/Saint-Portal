//
//  CourseworkSubmissionHandler.h
//  Saint Portal
//
//  Created by David Foster on 22/12/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "coursework.h"

@class CourseworkSubmissionHandler;

@protocol CourseworkSubmissionDelegate

-(void)CourseworkUploadSuccess;

-(void)CourseworkUploadFailure;

@end

@interface CourseworkSubmissionHandler : NSObject

-(void)submitCourseworkForItem:(Coursework *)coursework withFile:(NSURL *)url withDelegate:(id)delegate;

@end
