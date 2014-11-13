//
//  UpdateModuleTopics.m
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "UpdateModuleTopics.h"
#import "SaintPortalAPI.h"
#import "AppDelegate.h"
#import "Topics.h"
#import "UpdateTopicPosts.h"

@interface UpdateModuleTopics () <SaintPortalAPIDelegate, UpdateTopicPostsDelegate>
@property (nonatomic, strong)Modules *module;
@property (nonatomic, strong)NSManagedObjectContext *context;
@property (nonatomic, strong)id delegate;
@property BOOL status;
@property (nonatomic) NSInteger topicsCount;
@property (nonatomic) NSInteger topicsReturned;
@end

@implementation UpdateModuleTopics

-(void)updateTopicsForModule:(Modules *)module withDelegate:(id)delegate{
    
    self.module = module;
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.delegate = delegate;
    self.status = false;
    
    self.topicsReturned = 0;
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:self.module.module_id forKey:@"module_id"];
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    [api APIRequest:UpdateModuleTopicsRequest withData:data withDelegate:self];
    
}

-(void)APICallbackHandler:(NSDictionary *)data{
    
    
    
    NSMutableArray *topic_list = [[NSMutableArray alloc] init];
    
    NSMutableArray *topics = [[NSMutableArray alloc] init];
    
    if([[data valueForKey:@"topics_exist"] boolValue]){
        
        for(NSDictionary *topic in [data valueForKey:@"topics_details"]){
            
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
    
    //Remove any events not on core database
    NSArray *deletingTopics = [NSArray arrayWithArray:topic_list];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (topic_id IN %@)", deletingTopics];
    
    NSSet *topicsToDelete = [self.module.modules_topics filteredSetUsingPredicate:predicate];
    
    for(Topics *topic in topicsToDelete){
        [self.context deleteObject:topic];
        [self.module removeModules_topicsObject:topic];
    }
    
    NSError *error;
    [self.context save:&error];
    
    self.topicsCount = [topic_list count];
    
    NSArray *topics_array = [NSArray arrayWithArray:topics];
    
    for(Topics *topic in topics_array){
        
        UpdateTopicPosts *utp = [[UpdateTopicPosts alloc] init];
        [utp updatePostsForTopic:topic withDelegate:self];
    }
    
    if(self.topicsCount == self.topicsReturned){
        self.status = true;
        [self.delegate moduleTopicsUpdateSuccess];
    }
    
}

-(void) APIErrorHandler:(NSError *)error{
    
    self.status = true;
    
    [self.delegate moduleTopicsUpdateFailure:error];
    
}

-(void)topicPostsUpdateSuccess{
    
    self.topicsReturned++;
    
    if(self.topicsReturned == self.topicsCount){
        
        self.status = true;
        [self.delegate moduleTopicsUpdateSuccess];
    }
    
}

-(void)topicPostsUpdateFailure:(NSError *)error{
    
    self.topicsReturned++;
    
    if(self.topicsReturned == self.topicsCount){
        
        self.status = true;
        [self.delegate moduleTopicsUpdateSuccess];
    }
    
}

-(BOOL)getStatus{
    
    return self.status;
    
}

@end
