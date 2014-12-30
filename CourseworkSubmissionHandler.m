//
//  CourseworkSubmissionHandler.m
//  Saint Portal
//
//  Created by David Foster on 22/12/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "CourseworkSubmissionHandler.h"
#import "SaintPortalAPI.h"

@interface CourseworkSubmissionHandler() <SaintPortalAPIDelegate>
@property (strong, nonatomic) id delegate;
@end

@implementation CourseworkSubmissionHandler

-(void)submitCourseworkForItem:(Coursework *)coursework withFile:(NSURL *)url withDelegate:(id)delegate{
    
    self.delegate = delegate;
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    NSData *fileData = [NSData dataWithContentsOfURL:url];
    
    [data setValue:fileData forKey:@"fileData"];
    [data setValue:coursework.coursework_id forKey:@"courseworkid"];
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    [api APIRequest:UploadCourseworkSubmission withData:data withDelegate:self];
    
}

-(void)APICallbackHandler:(NSDictionary *)data{
    
    [self.delegate CourseworkUploadSuccess];
        
}

-(void)APIErrorHandler:(NSError *)error{
    
    [self.delegate CourseworkUploadFailure];
    
}

@end
