//
//  UpdatePersonalDetailsHandler.h
//  Saint Portal
//
//  Created by David Foster on 28/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdatePersonalDetailsHandler : NSObject

-(void)UpdatePersonalDetails;
-(void)UpdatePersonalDetailsWithDelegate:(id)delegate;
-(BOOL)getStatus;

@end
