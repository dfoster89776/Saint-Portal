//
//  UpdateTopicItem.m
//  Saint Portal
//
//  Created by David Foster on 03/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "UpdateTopicItem.h"
#import "AppDelegate.h"
#import "SaintPortalAPI.h"
#import "Topics.h"
#import "UpdateTopicPosts.h"
#import "Modules.h"

@interface UpdateTopicItem ()
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSManagedObjectContext* context;
@property (strong, nonatomic) Modules* module;
@end

@implementation UpdateTopicItem

-(void)updateTopicItemWithID:(NSNumber *)topic_id withDelegate:(id)delegate{
    
    NSLog(@"Updating post item for id: %i", [topic_id intValue]);
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.delegate = delegate;
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:topic_id forKey:@"topic_id"];
    
    [api APIRequest:UpdateTopicItemRequest withData:data withDelegate:self];
}



-(void)APICallbackHandler:(NSDictionary *)data{
    
    NSError* error;
    
    NSMutableArray *topic_list = [[NSMutableArray alloc] init];
    
    NSMutableArray *topics = [[NSMutableArray alloc] init];
    
    if([[data valueForKey:@"topics_exist"] boolValue]){
        
        for(NSDictionary *topic in [data valueForKey:@"topics_details"]){
            
            NSLog(@"ADD TOPIC DATA: %@", topic);
            
            int moduleid = [[topic objectForKey:@"module_id"] intValue];
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Modules"];
            request.predicate = [NSPredicate predicateWithFormat:@"module_id = %i", moduleid];
            
            NSArray* result = [self.context executeFetchRequest:request error:&error];
            
            self.module = [result firstObject];
            
            NSLog(@"ADDING TOPIC TO MODULE: %@", self.module);
            
            [topic_list addObject:[NSNumber numberWithInteger:[[topic objectForKey:@"topic_id"] integerValue]]];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topic_id == %i", [[topic objectForKey:@"topic_id"] integerValue]];
            
            NSSet *matches = [self.module.modules_topics filteredSetUsingPredicate:predicate];
            
            Topics *new_topic = nil;
            
            if([matches count] == 0){
                
                new_topic = [NSEntityDescription insertNewObjectForEntityForName:@"Topics" inManagedObjectContext:self.context];
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                new_topic.topic_id = [NSNumber numberWithInteger:[[topic objectForKey:@"topic_id"] integerValue]];
                new_topic.topic_name = [topic objectForKey:@"topic_name"];
                new_topic.topic_description = [topic objectForKey:@"topic_description"];
                new_topic.topic_order = [NSNumber numberWithInteger:[[topic objectForKey:@"topic_order"] integerValue]];
                new_topic.topics_module = self.module;
                
                [self.module addModules_topicsObject:new_topic];
                
            }else{
                
                new_topic = [[matches allObjects] firstObject];
                
                new_topic.topic_id = [NSNumber numberWithInteger:[[topic objectForKey:@"topic_id"] integerValue]];
                new_topic.topic_name = [topic objectForKey:@"topic_name"];
                new_topic.topic_description = [topic objectForKey:@"topic_description"];
                new_topic.topic_order = [NSNumber numberWithInteger:[[topic objectForKey:@"topic_order"] integerValue]];
                new_topic.topics_module = self.module;
            }
            
            [topics addObject:new_topic];
            
            NSError *error;
            [self.context save:&error];
        }
        
    }
    
    [self.context save:&error];
    
    NSArray *topics_array = [NSArray arrayWithArray:topics];
    
    for(Topics *topic in topics_array){
        
        UpdateTopicPosts *utp = [[UpdateTopicPosts alloc] init];
        [utp updatePostsForTopic:topic withDelegate:self];
    }
}

-(void)APIErrorHandler:(NSError *)error{
    
    [self.delegate topicItemUpdateFailure:error];
    
}

-(void)topicPostsUpdateSuccess{
    
    
    [self.delegate topicItemUpdateSuccess];
}

-(void)topicPostsUpdateFailure:(NSError *)error{
    
    [self.delegate topicPostsUpdateFailure:error];
    
}

@end
