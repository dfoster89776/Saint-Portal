//
//  UpdateEventItem.h
//  Saint Portal
//
//  Created by David Foster on 13/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UpdateEventItem;
@protocol UpdateEventItemDelegate

-(void)eventItemUpdateSuccess;
-(void)eventItemUpdateFailure:(NSError *)error;
@end

@interface UpdateEventItem : NSObject

-(void)updateEventItemWithID:(NSNumber *)event_id withDelegate:(id)delegate;

@end