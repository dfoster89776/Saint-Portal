//
//  SetupPersonalDetails.h
//  Saint Portal
//
//  Created by David Foster on 23/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetupViewController.h"

@interface SetupPersonalDetails : NSObject

-(void)setSetupController:(SetupViewController *)setupVC;
-(BOOL)getStatus;
@end
