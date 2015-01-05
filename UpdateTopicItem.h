//
//  UpdateTopicItem.h
//  Saint Portal
//
//  Created by David Foster on 03/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UpdateTopicItem;
@protocol UpdateTopicItemDelegate

-(void)topicItemUpdateSuccess;
-(void)topicItemUpdateFailure:(NSError *)error;
@end

@interface UpdateTopicItem : NSObject

-(void)updateTopicItemWithID:(NSNumber *)topic_id withDelegate:(id)delegate;

@end