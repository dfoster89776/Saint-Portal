//
//  UpdatePostItem.m
//  Saint Portal
//
//  Created by David Foster on 03/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "UpdatePostItem.h"
#import "AppDelegate.h"
#import "SaintPortalAPI.h"
#import "Posts.h"
#import "Slides.h"
#import "Examples.h"
#import "DirectoryUpdate.h"
#import "Topics.h"

@interface UpdatePostItem () <SaintPortalAPIDelegate>
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSManagedObjectContext* context;
@property (strong, nonatomic) Topics* topic;
@end

@implementation UpdatePostItem

-(void)updatePostItemWithID:(NSNumber *)post_id withDelegate:(id)delegate{
    
    NSLog(@"Updating post item for id: %i", [post_id intValue]);
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.delegate = delegate;
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:post_id forKey:@"post_id"];
    
    [api APIRequest:UpdatePostItemRequest withData:data withDelegate:self];
    }

-(void)APICallbackHandler:(NSDictionary *)data{
    
    NSError* error;
    
    NSMutableArray *post_list = [[NSMutableArray alloc] init];
    
    if([[data valueForKey:@"posts_exist"] boolValue]){
        
        for(NSDictionary *post in [data valueForKey:@"posts_details"]){
            
            int topicid = [[data objectForKey:@"topic_id"] intValue];
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Topics"];
            request.predicate = [NSPredicate predicateWithFormat:@"topic_id = %i", topicid];
            
            NSArray* result = [self.context executeFetchRequest:request error:&error];
            
            self.topic = [result firstObject];
            
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
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
            
        }
        
    }
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
    [self.delegate postItemUpdateSuccess];
    
}

-(void)APIErrorHandler:(NSError *)error{
    
    [self.delegate postItemUpdateFailure:error];
    
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
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
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
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
}

-(void)updateExamplesForPost:(Posts *)post withData:(NSArray *)data{
    
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
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
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
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
}


@end
