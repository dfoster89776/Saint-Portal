//
//  UpdateEnrolledModules.h
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UpdateEnrolledModules;

@protocol UpdateEnrolledModulesDelegate

-(void)moduleEnrollmentUpdateSuccess;
-(void)moduleEnrollmentUpdateFailure:(NSError*)error;

@end

@interface UpdateEnrolledModules : NSObject
-(void)UpdateEnrolledModulesWithDelegate:(id)delegate;
@end
