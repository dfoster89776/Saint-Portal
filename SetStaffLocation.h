//
//  SetStaffLocation.h
//  Saint Portal
//
//  Created by David Foster on 11/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Staff.h"

@interface SetStaffLocation : NSObject

-(void)setLocationForStaff:(Staff *)staff withLocationID:(int)location_id;

@end
