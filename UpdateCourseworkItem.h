//
//  UpdateCourseworkItem.h
//  Saint Portal
//
//  Created by David Foster on 09/12/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UpdateCourseworkItem;
@protocol UpdateCourseworkItemDelegate

-(void)courseworkItemUpdateSuccess;
-(void)courseworkItemUpdateFailure:(NSError *)error;
@end

@interface UpdateCourseworkItem : NSObject

-(void)updateCourseworkItemWithID:(NSNumber *)coursework_id withDelegate:(id)delegate;

@end
