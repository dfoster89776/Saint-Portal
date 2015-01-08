//
//  UpdateModuleCoursework.m
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "UpdateModuleCoursework.h"
#import "SaintPortalAPI.h"
#import "AppDelegate.h"
#import "Coursework.h"
#import "Specification.h"
#import "Coursework_Directory.h"
#import "DirectoryUpdate.h"
#import "Feedback.h"
#import "Submission.h"

@interface UpdateModuleCoursework() <SaintPortalAPIDelegate>
@property (nonatomic, strong)Modules *module;
@property (nonatomic, strong)NSManagedObjectContext *context;
@property (nonatomic, strong)id delegate;
@property BOOL status;
@end

@implementation UpdateModuleCoursework

-(void)updateCourseworkForModule:(Modules *)module withDelegate:(id)delegate{
    
    self.module = module;
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.delegate = delegate;
    self.status = false;
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:self.module.module_id forKey:@"module_id"];
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    [api APIRequest:UpdateModuleCourseworkRequest withData:data withDelegate:self];
    
}

-(void)APICallbackHandler:(NSDictionary *)data{
 
    NSMutableArray *assignment_list = [[NSMutableArray alloc] init];
    
    //Check all objects are in core data
    
    if([[data valueForKey:@"coursework_exists"] boolValue]){
        
        for (NSDictionary *assignment in [data valueForKey:@"coursework_details"]){
            
            [assignment_list addObject:[NSNumber numberWithInteger:[[assignment objectForKey:@"coursework_id"] integerValue]]];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"coursework_id == %i", [[assignment objectForKey:@"coursework_id"] integerValue]];
            
            NSSet *matches = [self.module.module_assignments filteredSetUsingPredicate:predicate];
            
            if([matches count] == 0){
                
                Coursework *new_coursework = [NSEntityDescription insertNewObjectForEntityForName:@"Coursework"
                                                                           inManagedObjectContext:self.context];
                
                new_coursework.coursework_id = [NSNumber numberWithInteger:[[assignment objectForKey:@"coursework_id"] integerValue]];
                new_coursework.coursework_name = [assignment objectForKey:@"coursework_name"];
                new_coursework.assignments_module = self.module;
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dueDate = [df dateFromString:[assignment objectForKey:@"due_date"]];
                
                new_coursework.coursework_due = dueDate;
                
                NSDate *feedbackDate = [df dateFromString:[assignment objectForKey:@"feedback_date"]];
                new_coursework.coursework_feedback_date = feedbackDate;
                
                new_coursework.coursework_weighting = [NSNumber numberWithInteger:[[assignment objectForKey:@"weighting"] integerValue]];
                
                new_coursework.coursework_description = [assignment objectForKey:@"description"];

                if([assignment objectForKey:@"directory_details"]){
                    [self updateDirectoryForCoursework:new_coursework withData:assignment];
                }
                
                new_coursework.specification = new_coursework.specification = [UpdateModuleCoursework updateCourseworkFile:[assignment objectForKey:@"coursework_file"] withContext:self.context];
                
                new_coursework.submitted = [NSNumber numberWithInteger:[[assignment objectForKey:@"submitted"] integerValue]];
                new_coursework.feedback_received = [NSNumber numberWithInteger:[[assignment objectForKey:@"feedback_received"] integerValue]];
                
                if(new_coursework.feedback_received){
                    
                    NSMutableDictionary *feedbackData = [assignment objectForKey:@"feedback"];
                    
                    Feedback* feedback = [NSEntityDescription insertNewObjectForEntityForName:@"Feedback" inManagedObjectContext:self.context];
                    
                    new_coursework.feedback = feedback;
                    
                    NSDate *feedbackReceived = [df dateFromString:[feedbackData objectForKey:@"feedback_time"]];
                    feedback.received = feedbackReceived;
                    
                    feedback.coursework_item = new_coursework;
                    feedback.grade = [NSNumber numberWithInteger:[[feedbackData objectForKey:@"grade"] floatValue]];
                    feedback.comment = [feedbackData objectForKey:@"comment"];
                    
                    NSLog(@"Feedback received");
                    
                }
                
                [self.module addModule_assignmentsObject:new_coursework];
                
                [self updateLocalNotificationsForCoursework:new_coursework];
                
            }else if([matches count] > 0){
                
                Coursework *new_coursework = [[matches allObjects] firstObject];
                new_coursework.coursework_id = [NSNumber numberWithInteger:[[assignment objectForKey:@"coursework_id"] integerValue]];
                new_coursework.coursework_name = [assignment objectForKey:@"coursework_name"];
                new_coursework.assignments_module = self.module;
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dueDate = [df dateFromString:[assignment objectForKey:@"due_date"]];
                
                new_coursework.coursework_due = dueDate;
                
                NSDate *feedbackDate = [df dateFromString:[assignment objectForKey:@"feedback_date"]];
                new_coursework.coursework_feedback_date = feedbackDate;
                
                new_coursework.coursework_weighting = [NSNumber numberWithInteger:[[assignment objectForKey:@"weighting"] integerValue]];
                
                new_coursework.coursework_description = [assignment objectForKey:@"description"];
                
                new_coursework.submitted = [NSNumber numberWithInteger:[[assignment objectForKey:@"submitted"] integerValue]];
                new_coursework.feedback_received = [NSNumber numberWithInteger:[[assignment objectForKey:@"feedback_received"] integerValue]];
                
                if(new_coursework.feedback_received){
                    
                    NSMutableDictionary *feedbackData = [assignment objectForKey:@"feedback"];
                    
                    Feedback* feedback;
                    
                    if(new_coursework.feedback == nil){
                         feedback = [NSEntityDescription insertNewObjectForEntityForName:@"Feedback" inManagedObjectContext:self.context];
                    }else{
                        feedback = new_coursework.feedback;
                    }
                    
                    new_coursework.feedback = feedback;
                    
                    NSDate *feedbackReceived = [df dateFromString:[feedbackData objectForKey:@"feedback_time"]];
                    feedback.received = feedbackReceived;
                    
                    feedback.coursework_item = new_coursework;
                    feedback.grade = [NSNumber numberWithInteger:[[feedbackData objectForKey:@"grade"] floatValue]];
                    feedback.comment = [feedbackData objectForKey:@"comment"];
                    
                    //NSLog(@"Feedback received");
                    
                }
                
                if(new_coursework.submitted){
                    
                    NSMutableDictionary *submissionData = [assignment objectForKey:@"submission"];
                    
                    new_coursework.submission = [UpdateModuleCoursework updateSubmissionFile:submissionData withContext:self.context];
                    
                }

                
                if([assignment objectForKey:@"directory_details"]){
                    [self updateDirectoryForCoursework:new_coursework withData:assignment];
                }else if (new_coursework.coursework_directory != nil){
                    [self.context deleteObject:new_coursework.coursework_directory];
                    new_coursework.coursework_directory = nil;
                }
                
                new_coursework.specification = [UpdateModuleCoursework updateCourseworkFile:[assignment objectForKey:@"coursework_file"] withContext:self.context];
                
                [self updateLocalNotificationsForCoursework:new_coursework];
            }
        }
    }
    
    //Remove any coursework items no longer on central database
    NSArray *deleteingAssignmenets = [NSArray arrayWithArray:assignment_list];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (coursework_id IN %@)", deleteingAssignmenets];
    
    NSSet *assignmentsToDelete = [self.module.module_assignments filteredSetUsingPredicate:predicate];
    
    for(Coursework *deleteCoursework in assignmentsToDelete){
        
        [self.context deleteObject:deleteCoursework];
        [self.module removeModule_assignmentsObject:deleteCoursework];
    }
 
    self.status = true;
    
    NSError *error;
    [self.context save:&error];
    
    [self.delegate moduleCourseworkUpdateSuccess];
    
}

-(void) APIErrorHandler:(NSError *)error{

    self.status = true;
    
    [self.delegate moduleCourseworkUpdateFailure:error];
    
}

-(BOOL)getStatus{
    
    return self.status;
    
}

+(Specification *)updateCourseworkFile:(NSDictionary *)fileData withContext:(NSManagedObjectContext*)context{
    
    Specification *file;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Specification"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"file_id = %@", [fileData objectForKey:@"file_id"]];
    
    NSError *error = nil;
    NSUInteger count = [context countForFetchRequest:request error:&error];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if(count == 0){
        
        file = [NSEntityDescription insertNewObjectForEntityForName:@"Specification"
                                                            inManagedObjectContext:context];
        
        file.file_id = [NSNumber numberWithInteger:[[fileData objectForKey:@"file_id"] integerValue]];
        file.file_url = [fileData objectForKey:@"file_url"];
        
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

-(void)updateDirectoryForCoursework:(Coursework *)coursework withData:(NSDictionary *)data{
    
    //NSLog(@"Updating coursework directory: %@", [data objectForKey:@"directory"]);
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coursework_Directory"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"directory_id = %@", [data objectForKey:@"directory"]];
    
    NSError *error = nil;
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    
    Coursework_Directory *root;
    
    if(count == 0){
        
        root = [NSEntityDescription insertNewObjectForEntityForName:@"Coursework_Directory"
                                                   inManagedObjectContext:self.context];
        
    }else if (count == 1){
        
        NSArray *details = [self.context executeFetchRequest:request error:&error];
        root = [details firstObject];
    
    }
    
    root.directory_id = [NSNumber numberWithInteger:[[data objectForKey:@"directory"] integerValue]];
    
    coursework.coursework_directory = root;
    
    DirectoryUpdate *du = [[DirectoryUpdate alloc] init];
    [du updateCourseworkDirectory:root withData:[data objectForKey:@"directory_details"]];
    
}

-(void)updateLocalNotificationsForCoursework:(Coursework *)coursework{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm EEE dd/MM/yyyy"];
    
    //Delete old notifications
    [UpdateModuleCoursework deleteLocalNotificationWithID:coursework.notification_48];
    
    [UpdateModuleCoursework deleteLocalNotificationWithID:coursework.notification_24];
    
    [UpdateModuleCoursework deleteLocalNotificationWithID:coursework.notification_12];
    
    [UpdateModuleCoursework deleteLocalNotificationWithID:coursework.notification_6];
    
    [UpdateModuleCoursework deleteLocalNotificationWithID:coursework.notification_2];
    
    [UpdateModuleCoursework deleteLocalNotificationWithID:coursework.notification_10];
        
    //Current notification_id
    int notification_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"local_notification_id"] intValue];
    
    if([coursework.submitted boolValue]){
        
        if([[NSDate dateWithTimeIntervalSinceNow:600] compare:coursework.coursework_due] == NSOrderedAscending){
            
            NSLog(@"Local Notification Created For: %@", coursework.coursework_name);
            NSDate *fireDate = [NSDate dateWithTimeInterval:-600 sinceDate:coursework.coursework_due];
            NSLog(@"Fire Date: %@", [df stringFromDate:fireDate]);
            
            
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            
            localNotif.fireDate = fireDate;
            localNotif.alertBody = [NSString stringWithFormat:@"You have 10 minutes to make any changes to your submission for %@: %@", coursework.assignments_module.module_code, coursework.coursework_name];
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            int localNotifId;
            if(coursework.notification_10 == nil) {
                localNotifId = notification_id;
                coursework.notification_10 = [NSNumber numberWithInt:localNotifId];
                notification_id++;
            }else{
                localNotifId = [coursework.notification_10 intValue];
            }
            [dict setValue:[NSNumber numberWithInt:localNotifId] forKey:@"id"];
            [dict setValue:coursework.coursework_id forKey:@"coursework_id"];
            [dict setValue:@"coursework_reminder" forKey:@"type"];
            localNotif.userInfo = dict;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
    }else{
        
        //Set 10 minute notification
        if([[NSDate dateWithTimeIntervalSinceNow:600] compare:coursework.coursework_due] == NSOrderedAscending){
            
            NSLog(@"Local Notification Created For: %@", coursework.coursework_name);
            NSDate *fireDate = [NSDate dateWithTimeInterval:-600 sinceDate:coursework.coursework_due];
            NSLog(@"Fire Date: %@", [df stringFromDate:fireDate]);
            
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            
            localNotif.fireDate = [NSDate dateWithTimeInterval:-600 sinceDate:coursework.coursework_due];
            localNotif.alertBody = [NSString stringWithFormat:@"You have 10 minutes till the submission deadline for %@: %@", coursework.assignments_module.module_code, coursework.coursework_name];
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            int localNotifId;
            if(coursework.notification_10 == nil) {
                localNotifId = notification_id;
                coursework.notification_10 = [NSNumber numberWithInt:localNotifId];
                notification_id++;
            }else{
                localNotifId = [coursework.notification_10 intValue];
            }
            [dict setValue:[NSNumber numberWithInt:localNotifId] forKey:@"id"];
            [dict setValue:coursework.coursework_id forKey:@"coursework_id"];
            [dict setValue:@"coursework_reminder" forKey:@"type"];
            localNotif.userInfo = dict;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
        
        if([[NSDate dateWithTimeIntervalSinceNow:7200] compare:coursework.coursework_due] == NSOrderedAscending){
            
            NSLog(@"Local Notification Created For: %@", coursework.coursework_name);
            NSDate *fireDate = [NSDate dateWithTimeInterval:-7200 sinceDate:coursework.coursework_due];
            NSLog(@"Fire Date: %@", [df stringFromDate:fireDate]);
            
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            
            localNotif.fireDate = [NSDate dateWithTimeInterval:-7200 sinceDate:coursework.coursework_due];
            localNotif.alertBody = [NSString stringWithFormat:@"You have 2 hours till the submission deadline for %@: %@", coursework.assignments_module.module_code, coursework.coursework_name];
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            int localNotifId;
            if(coursework.notification_2 == nil) {
                localNotifId = notification_id;
                coursework.notification_2 = [NSNumber numberWithInt:localNotifId];
                notification_id++;
            }else{
                localNotifId = [coursework.notification_2 intValue];
            }
            [dict setValue:[NSNumber numberWithInt:localNotifId] forKey:@"id"];
            [dict setValue:coursework.coursework_id forKey:@"coursework_id"];
            [dict setValue:@"coursework_reminder" forKey:@"type"];
            localNotif.userInfo = dict;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
        
        if([[NSDate dateWithTimeIntervalSinceNow:21600] compare:coursework.coursework_due] == NSOrderedAscending){
            
            NSLog(@"Local Notification Created For: %@", coursework.coursework_name);
            NSDate *fireDate = [NSDate dateWithTimeInterval:-21600 sinceDate:coursework.coursework_due];
            NSLog(@"Fire Date: %@", [df stringFromDate:fireDate]);
            
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            
            localNotif.fireDate = [NSDate dateWithTimeInterval:-21600 sinceDate:coursework.coursework_due];
            localNotif.alertBody = [NSString stringWithFormat:@"You have 6 hours till the submission deadline for %@: %@", coursework.assignments_module.module_code, coursework.coursework_name];
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            int localNotifId;
            if(coursework.notification_6 == nil) {
                localNotifId = notification_id;
                coursework.notification_6 = [NSNumber numberWithInt:localNotifId];
                notification_id++;
            }else{
                localNotifId = [coursework.notification_6 intValue];
            }
            [dict setValue:[NSNumber numberWithInt:localNotifId] forKey:@"id"];
            [dict setValue:coursework.coursework_id forKey:@"coursework_id"];
            [dict setValue:@"coursework_reminder" forKey:@"type"];
            localNotif.userInfo = dict;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
        
        if([[NSDate dateWithTimeIntervalSinceNow:43200] compare:coursework.coursework_due] == NSOrderedAscending){
            
            NSLog(@"Local Notification Created For: %@", coursework.coursework_name);
            NSDate *fireDate = [NSDate dateWithTimeInterval:-43200 sinceDate:coursework.coursework_due];
            NSLog(@"Fire Date: %@", [df stringFromDate:fireDate]);
            
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            
            localNotif.fireDate = [NSDate dateWithTimeInterval:-43200 sinceDate:coursework.coursework_due];
            localNotif.alertBody = [NSString stringWithFormat:@"You have 12 hours till the submission deadline for %@: %@", coursework.assignments_module.module_code, coursework.coursework_name];
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            int localNotifId;
            if(coursework.notification_12 == nil) {
                localNotifId = notification_id;
                coursework.notification_12 = [NSNumber numberWithInt:localNotifId];
                notification_id++;
            }else{
                localNotifId = [coursework.notification_12 intValue];
            }
            [dict setValue:[NSNumber numberWithInt:localNotifId] forKey:@"id"];
            [dict setValue:coursework.coursework_id forKey:@"coursework_id"];
            [dict setValue:@"coursework_reminder" forKey:@"type"];
            localNotif.userInfo = dict;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
        
        if([[NSDate dateWithTimeIntervalSinceNow:86400] compare:coursework.coursework_due] == NSOrderedAscending){
            
            NSLog(@"Local Notification Created For: %@", coursework.coursework_name);
            NSDate *fireDate = [NSDate dateWithTimeInterval:-86400 sinceDate:coursework.coursework_due];
            NSLog(@"Fire Date: %@", [df stringFromDate:fireDate]);
            
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            
            localNotif.fireDate = [NSDate dateWithTimeInterval:-86400 sinceDate:coursework.coursework_due];
            localNotif.alertBody = [NSString stringWithFormat:@"You have 1 day till the submission deadline for %@: %@", coursework.assignments_module.module_code, coursework.coursework_name];
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            int localNotifId;
            if(coursework.notification_24 == nil) {
                localNotifId = notification_id;
                coursework.notification_24 = [NSNumber numberWithInt:localNotifId];
                notification_id++;
            }else{
                localNotifId = [coursework.notification_24 intValue];
            }
            [dict setValue:[NSNumber numberWithInt:localNotifId] forKey:@"id"];
            [dict setValue:coursework.coursework_id forKey:@"coursework_id"];
            [dict setValue:@"coursework_reminder" forKey:@"type"];
            localNotif.userInfo = dict;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
        
        if([[NSDate dateWithTimeIntervalSinceNow:172800] compare:coursework.coursework_due] == NSOrderedAscending){
            
            NSLog(@"Local Notification Created For: %@", coursework.coursework_name);
            NSDate *fireDate = [NSDate dateWithTimeInterval:-172800 sinceDate:coursework.coursework_due];
            NSLog(@"Fire Date: %@", [df stringFromDate:fireDate]);
            
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            
            localNotif.fireDate = [NSDate dateWithTimeInterval:-172800 sinceDate:coursework.coursework_due];
            localNotif.alertBody = [NSString stringWithFormat:@"You have 2 days till the submission deadline for %@: %@", coursework.assignments_module.module_code, coursework.coursework_name];
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            int localNotifId;
            if(coursework.notification_48 == nil) {
                localNotifId = notification_id;
                coursework.notification_48 = [NSNumber numberWithInt:localNotifId];
                notification_id++;
            }else{
                localNotifId = [coursework.notification_48 intValue];
            }
            [dict setValue:[NSNumber numberWithInt:localNotifId] forKey:@"id"];
            [dict setValue:coursework.coursework_id forKey:@"coursework_id"];
            [dict setValue:@"coursework_reminder" forKey:@"type"];
            localNotif.userInfo = dict;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:notification_id] forKey:@"local_notification_id"];
    
}

+(void)deleteLocalNotificationWithID:(NSNumber *)notificationid{
    
    if(notificationid != nil){
    
        UILocalNotification *notificationToDelete = [UpdateModuleCoursework getNotificationWithID:notificationid];
        
        if(notificationToDelete != nil){
            [[UIApplication sharedApplication] cancelLocalNotification:notificationToDelete];
        }
    }
}

+(UILocalNotification *)getNotificationWithID:(NSNumber *)notification_id{

    if(notification_id != nil){
        NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
        for (UILocalNotification *notification in allNotifications){
            
            if ([[notification.userInfo objectForKey:@"id"] intValue] == [notification_id intValue]){
                return notification;
            }
            
        }
    }

    return nil;
    
}

@end
