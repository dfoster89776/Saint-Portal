//
//  UpdatePostItem.h
//  Saint Portal
//
//  Created by David Foster on 03/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UpdatePostItem;
@protocol UpdatePostItemDelegate

-(void)postItemUpdateSuccess;
-(void)postItemUpdateFailure:(NSError *)error;
@end

@interface UpdatePostItem : NSObject

-(void)updatePostItemWithID:(NSNumber *)post_id withDelegate:(id)delegate;

@end