//
//  AppDelegate.h
//  Saint Portal
//
//  Created by David Foster on 21/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <EventKit/EventKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (readonly, nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)clearPersistentStore;

-(void)displayCourseworkItemWithId:(NSNumber *)coursework_id;
-(void)displayEventItemWithId:(NSNumber *)event_id;

-(void)updateBadge;
@end

