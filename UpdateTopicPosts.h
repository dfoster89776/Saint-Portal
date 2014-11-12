//
//  UpdateTopicPosts.h
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topics.h"

@class UpdateTopicPosts;

@protocol UpdateTopicPostsDelegate

-(void)topicPostsUpdateSuccess;
-(void)topicPostsUpdateFailure:(NSError*)error;

@end

@interface UpdateTopicPosts : NSObject

-(void)updatePostsForTopic:(Topics *)topic withDelegate:(id)delegate;
-(BOOL)getStatus;

@end