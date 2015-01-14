//
//  CourseworkSubmissionHandler.m
//  Saint Portal
//
//  Created by David Foster on 22/12/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "CourseworkSubmissionHandler.h"
#import "SaintPortalAPI.h"
#import "Submission.h"
#import "AppDelegate.h"

@interface CourseworkSubmissionHandler() <SaintPortalAPIDelegate>
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) Coursework *coursework;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation CourseworkSubmissionHandler

-(void)submitCourseworkForItem:(Coursework *)coursework withFile:(NSURL *)url withDelegate:(id)delegate{
    
    self.delegate = delegate;
    self.coursework = coursework;
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    NSData *fileData = [NSData dataWithContentsOfURL:url];
    
    [data setValue:fileData forKey:@"fileData"];
    [data setValue:coursework.coursework_id forKey:@"courseworkid"];
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    [api APIRequest:UploadCourseworkSubmission withData:data withDelegate:self];
    
}

-(void)APICallbackHandler:(NSDictionary *)data{
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.coursework.submitted = [NSNumber numberWithBool:true];
    
    NSMutableDictionary *submissionData = [data objectForKey:@"submission"];
        
    self.coursework.submission = [CourseworkSubmissionHandler updateSubmissionFile:submissionData withContext:self.context];
    
    NSError* error;
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
    [self.delegate CourseworkUploadSuccess];
    
}

-(void)APIErrorHandler:(NSError *)error{
    
    [self.delegate CourseworkUploadFailure];
    
}

+(Submission *)updateSubmissionFile:(NSDictionary *)submissionData withContext:(NSManagedObjectContext*)context{
    
    Submission *file;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDictionary *fileData = [submissionData objectForKey:@"file_details"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Submission"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"file_id = %@", [fileData objectForKey:@"file_id"]];
    
    NSError *error = nil;
    NSUInteger count = [context countForFetchRequest:request error:&error];
    
    if(count == 0){
        
        file = [NSEntityDescription insertNewObjectForEntityForName:@"Submission"
                                             inManagedObjectContext:context];
        
        file.file_id = [NSNumber numberWithInteger:[[fileData objectForKey:@"file_id"] integerValue]];
        file.file_url = [fileData objectForKey:@"file_url"];
        file.submission_time = [df dateFromString:[submissionData objectForKey:@"submission_date_time"]];
        
        //NSLog(@"File url: %@", file.file_url);
        
        NSArray *parts = [file.file_url componentsSeparatedByString:@"/"];
        file.file_name = [parts lastObject];
        
        if(file.downloaded){
            
            NSDate *updated = [df dateFromString:[fileData objectForKey:@"last_modified"]];
            
            if(updated > file.downloaded){
                file.update_available = [NSNumber numberWithInt:1];
            }
        }
        
        
    }else{
        NSArray *files = [context executeFetchRequest:request error:&error];
        file = [files firstObject];
        
        //NSLog(@"Adding coursework file: %@", [fileData objectForKey:@"file_url"]);
        
        file.file_id = [NSNumber numberWithInteger:[[fileData objectForKey:@"file_id"] integerValue]];
        file.file_url = [fileData objectForKey:@"file_url"];
        file.submission_time = [df dateFromString:[submissionData objectForKey:@"submission_date_time"]];
        
        NSArray *parts = [file.file_url componentsSeparatedByString:@"/"];
        file.file_name = [parts lastObject];
        
        if(file.downloaded){
            
            NSDate *updated = [df dateFromString:[fileData objectForKey:@"last_modified"]];
            
            if(updated > file.downloaded){
                file.update_available = [NSNumber numberWithInt:1];
            }
        }
        
    }
    
    return file;
    
}

@end
