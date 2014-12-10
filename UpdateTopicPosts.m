//
//  UpdateTopicPosts.m
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "UpdateTopicPosts.h"
#import "AppDelegate.h"
#import "SaintPortalAPI.h"
#import "Posts.h"
#import "Topics.h"
#import "Slides.h"
#import "Examples.h"
#import "Directory.h"
#import "DirectoryUpdate.h"

@interface UpdateTopicPosts () <SaintPortalAPIDelegate>
@property (nonatomic, strong)Topics *topic;
@property (nonatomic, strong)NSManagedObjectContext *context;
@property (nonatomic, strong)id delegate;
@property BOOL status;
@end

@implementation UpdateTopicPosts

-(void)updatePostsForTopic:(Topics *)topic withDelegate:(id)delegate{
    
    self.topic = topic;
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.delegate = delegate;
    self.status = false;
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:self.topic.topic_id forKey:@"topic_id"];
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    [api APIRequest:UpdateTopicPostsRequest withData:data withDelegate:self];
    
}

-(void)APICallbackHandler:(NSDictionary *)data{
    
    //NSLog(@"POST UDPATED");
    
    NSMutableArray *post_list = [[NSMutableArray alloc] init];
    
    if([[data valueForKey:@"posts_exist"] boolValue]){
        
        for(NSDictionary *post in [data valueForKey:@"posts_details"]){
            
            [post_list addObject:[NSNumber numberWithInteger:[[post objectForKey:@"post_id"] integerValue]]];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"post_id == %i", [[post objectForKey:@"post_id"] integerValue]];
            
            NSSet *matches = [self.topic.topics_posts filteredSetUsingPredicate:predicate];
            
            if([matches count] == 0){
                
                Posts *new_post = [NSEntityDescription insertNewObjectForEntityForName:@"Posts" inManagedObjectContext:self.context];
                
                new_post.post_id = [NSNumber numberWithInteger:[[post objectForKey:@"post_id"] integerValue]];
                new_post.post_name = [post objectForKey:@"post_name"];
                new_post.post_description = [post objectForKey:@"post_description"];
                new_post.post_order = [NSNumber numberWithInteger:[[post objectForKey:@"post_order"] integerValue]];
                new_post.posts_topic = self.topic;
                
                [self updateSlidesForPost:new_post withData:[post objectForKey:@"slides_data"]];
                [self updateExamplesForPost:new_post withData:[post objectForKey:@"examples"]];
                
                [self.topic addTopics_postsObject:new_post];
                
            }else{
                
                Posts *new_post = [[matches allObjects] firstObject];
                
                new_post.post_id = [NSNumber numberWithInteger:[[post objectForKey:@"post_id"] integerValue]];
                new_post.post_name = [post objectForKey:@"post_name"];
                new_post.post_description = [post objectForKey:@"post_description"];
                new_post.post_order = [NSNumber numberWithInteger:[[post objectForKey:@"post_order"] integerValue]];
                new_post.posts_topic = self.topic;
                
                [self updateSlidesForPost:new_post withData:[post objectForKey:@"slides_data"]];
                [self updateExamplesForPost:new_post withData:[post objectForKey:@"examples"]];

            }
            
            NSError *error;
            [self.context save:&error];
            
        }
        
    }
    
    //Remove any events not on core database
    NSArray *deleteingPosts = [NSArray arrayWithArray:post_list];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (post_id IN %@)", deleteingPosts];
    
    NSSet *postsToDelete = [self.topic.topics_posts filteredSetUsingPredicate:predicate];
    
    for(Posts *post in postsToDelete){
        [self.context deleteObject:post];
        [self.topic removeTopics_postsObject:post];
    }
    
    NSError *error;
    [self.context save:&error];

    [self.delegate topicPostsUpdateSuccess];
    
}

-(void)APIErrorHandler:(NSError *)error{
    
    [self.delegate topicPostsUpdateFailure:error];
    
}

-(BOOL)getStatus{
    
    return self.status;
    
}


-(void)updateSlidesForPost:(Posts *)post withData:(NSArray *)data{
    
    NSMutableArray *slides_list = [[NSMutableArray alloc] init];
    
    for(NSMutableDictionary *slide in data){
        
        [slides_list addObject:[NSNumber numberWithInteger:[[slide objectForKey:@"file_id"] integerValue]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"file_id == %i", [[slide objectForKey:@"file_id"] integerValue]];
        
        NSSet *matches = [post.posts_slides filteredSetUsingPredicate:predicate];
        
        if([matches count] == 0){
            
            Slides *new_slide = [NSEntityDescription insertNewObjectForEntityForName:@"Slides" inManagedObjectContext:self.context];
            
            new_slide.file_id = [NSNumber numberWithInteger:[[slide objectForKey:@"file_id"] integerValue]];
            new_slide.name = [slide objectForKey:@"slides_name"];
            new_slide.file_url = [slide objectForKey:@"file_url"];
            NSArray *parts = [new_slide.file_url componentsSeparatedByString:@"/"];
            new_slide.file_name = [parts lastObject];
            new_slide.slides_post = post;
            
            [post addPosts_slidesObject:new_slide];
            
        }else{
            
            Slides *new_slide = [[matches allObjects] firstObject];
            
            new_slide.file_id = [NSNumber numberWithInteger:[[slide objectForKey:@"file_id"] integerValue]];
            new_slide.name = [slide objectForKey:@"slides_name"];
            new_slide.file_url = [slide objectForKey:@"file_url"];
            NSArray *parts = [new_slide.file_url componentsSeparatedByString:@"/"];
            new_slide.file_name = [parts lastObject];
            new_slide.slides_post = post;
            
        }
        
        NSError *error;
        [self.context save:&error];
    }
    
    //Remove any events not on core database
    NSArray *deletingSlides = [NSArray arrayWithArray:slides_list];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (file_id IN %@)", deletingSlides];
    
    NSSet *slidesToDelete = [post.posts_slides filteredSetUsingPredicate:predicate];
    
    for(Slides *slide in slidesToDelete){
        [self.context deleteObject:slide];
        [post removePosts_slidesObject:slide];
    }
    
    NSError *error;
    [self.context save:&error];
    
}

-(void)updateExamplesForPost:(Posts *)post withData:(NSArray *)data{
    
    //NSLog(@"%@", data);
    
    NSMutableArray *examples_list = [[NSMutableArray alloc] init];
    
    for(NSDictionary *example in data){
        
        [examples_list addObject:[NSNumber numberWithInteger:[[example objectForKey:@"example_id"] integerValue]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"example_id == %i", [[example objectForKey:@"example_id"] integerValue]];
        
        NSSet *matches = [post.posts_examples filteredSetUsingPredicate:predicate];
        
        if([matches count] == 0){
            
            Examples *new_example = [NSEntityDescription insertNewObjectForEntityForName:@"Examples" inManagedObjectContext:self.context];
            
            new_example.example_id = [NSNumber numberWithInteger:[[example objectForKey:@"example_id"] integerValue]];
            new_example.name = [example objectForKey:@"example_name"];
            new_example.examples_post = post;
            
            [post addPosts_examplesObject:new_example];
            
            DirectoryUpdate *du = [[DirectoryUpdate alloc] init];
            [du updateExamplesDirectory:new_example withData:[example objectForKey:@"directory_details"]];
            
            
        }else{
            
            Examples *new_example = [[matches allObjects] firstObject];
            
            new_example.example_id = [NSNumber numberWithInteger:[[example objectForKey:@"example_id"] integerValue]];
            new_example.name = [example objectForKey:@"example_name"];
            new_example.examples_post = post;
            
            DirectoryUpdate *du = [[DirectoryUpdate alloc] init];
            [du updateExamplesDirectory:new_example withData:[example objectForKey:@"directory_details"]];
            
        }
        
        
        
        NSError *error;
        [self.context save:&error];
    }
    
    //Remove any events not on core database
    NSArray *deleteingExamples = [NSArray arrayWithArray:examples_list];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (example_id IN %@)", deleteingExamples];
    
    NSSet *examplesToDelete = [post.posts_examples filteredSetUsingPredicate:predicate];
    
    for(Examples *example in examplesToDelete){
        [self.context deleteObject:example];
        [post removePosts_examplesObject:example];
    }
    
    NSError *error;
    [self.context save:&error];
    
}


@end
