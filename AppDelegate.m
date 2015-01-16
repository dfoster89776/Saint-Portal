//
//  AppDelegate.m
//  Saint Portal
//
//  Created by David Foster on 21/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "AppDelegate.h"
#import <EventKit/EventKit.h>
#import "UpdateAllModuleData.h"
#import "CourseworkDetailsViewController.h"
#import "CourseworkModalViewController.h"
#import "StAndrewsLocationManager.h"
#import "PushNotificationManager.h"
#import "RemoteNotificationReceiver.h"
#import "EventDetailsViewController.h"
#import "EventModalViewController.h"
#import "Notification.h"
#import "PostModalViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppDelegate () <UpdateAllModuleDataDelegate>
@property (nonatomic, copy) void (^completionHandler)(UIBackgroundFetchResult fetchResult);
@property (nonatomic, strong) StAndrewsLocationManager *salm;
@property (nonatomic, strong) PushNotificationManager *pnm;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    self.pnm = [[PushNotificationManager alloc] init];
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x00539B)];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/
                                                            255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0], NSFontAttributeName, nil]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"badge_count"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"badge_count"];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"last_notification"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"last_notification"];
    }
    
    
    // Load Main App Screen
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *homeScreenVC = nil;

    //Check if username is set in preferences, if so load dashboard view, otherwise display login screen
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] != nil){
        
        if(([[NSUserDefaults standardUserDefaults] objectForKey:@"setup_complete"] != nil)){
            homeScreenVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        }else{
            homeScreenVC = [storyboard instantiateViewControllerWithIdentifier:@"SetupViewController"];
        }
    }else{
        homeScreenVC = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    }

    //Display appropriate initial view
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = homeScreenVC;
    [self.window makeKeyAndVisible];
    
    self.salm = [[StAndrewsLocationManager alloc] init];
    [self.salm setupLocationManager];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveContext];
    [self.salm applicationEnteredBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self.salm applicationEnteredForeground];
    
    NSError *error;
    
    //Print list of posts
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Posts"];
    NSArray *posts = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    for(Posts *post in posts){
        
        NSLog(@"Post id: %@: %@", post.post_id, post.post_name);
        
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"badge_count"];
    [self updateBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "david.foster.Saint_Portal" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Saint_Portal" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *directory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.SaintAndrews"];
    NSURL *storeURL = [directory  URLByAppendingPathComponent:@"Saint_Portal.sqlite"];
        
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }else{
        [self addSkipBackupAttributeToItemAtURL:storeURL];
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)clearPersistentStore{
    
    NSPersistentStoreCoordinator *storeCoordinator = [self persistentStoreCoordinator];
    NSPersistentStore *store = [[storeCoordinator persistentStores] lastObject];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"dataModel"];
    NSError *error;
    
    [storeCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
    
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    
    if (storeCoordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:storeCoordinator];
    }
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    NSError *error = nil;
    [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    return error == nil;
}

-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation {
    
    NSMutableDictionary *query;
    
    if(url != nil){
        
        query = [AppDelegate urlQueryDictionaryFromString:[url query]];
    }
    
    if(query )
    
    if([query objectForKey:@"type"]){
     
        if([[query objectForKey:@"type"] isEqualToString:@"coursework"]){
            
            NSNumber *coursework_id = [NSNumber numberWithInteger:[[query objectForKey:@"coursework_id"] integerValue]];
        
            [self displayCourseworkItemWithId:coursework_id];
            
        }
        
        if([[query objectForKey:@"type"] isEqualToString:@"event"]){
            
            NSNumber *event_id = [NSNumber numberWithInteger:[[query objectForKey:@"event_id"] integerValue]];
            
            [self displayEventItemWithId:event_id];
            
        }
        
    }
     
    return YES;
}

+(NSMutableDictionary *)urlQueryDictionaryFromString:(NSString *)query{
    
    NSArray *components = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    for (NSString *component in components) {
        NSArray *subcomponents = [component componentsSeparatedByString:@"="];
        [parameters setObject:[[subcomponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                       forKey:[[subcomponents objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return parameters;
    
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    [self.pnm registerPushNotificationToken:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    [self.pnm registerPushNotificationFailure];
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    self.completionHandler = completionHandler;
    UpdateAllModuleData *umd = [[UpdateAllModuleData alloc] init];
    [umd updateAllModuleDataWithDelegate:self];
    
}

-(void)updateAllModuleDataSuccess{
    NSLog(@"All Module Data Update Success");
    
    self.completionHandler(UIBackgroundFetchResultNewData);
}

-(void)updateAllModuleDataFailure:(NSError *)error{
    NSLog(@"Module Data Update Failure");
    self.completionHandler(UIBackgroundFetchResultFailed);
}

- (void)           application:(UIApplication *)application
  didReceiveRemoteNotification:(NSDictionary *)userInfo
        fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    RemoteNotificationReceiver *rnr = [[RemoteNotificationReceiver alloc] init];
    
    if(application.applicationState == UIApplicationStateBackground){
        
        NSLog(@"Background notification processing");
        [rnr didReceiveNotification:userInfo withHandler:completionHandler  isUserOpened:NO];
        
    }else if (application.applicationState == UIApplicationStateInactive){
        
        NSLog(@"User selected notification");
        [rnr didReceiveNotification:userInfo withHandler:completionHandler  isUserOpened:YES];
    }else{
        
        [rnr didReceiveNotification:userInfo withHandler:completionHandler isUserOpened:NO];
        
    }
        
    
    // Do something with the content ID
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NSString *message =notification.alertBody;
    
    NSDictionary *userInfo = notification.userInfo;
    
    [self createNotificationWithMessage:message];
    
    if(application.applicationState == UIApplicationStateInactive){
    
        if([[userInfo objectForKey:@"type"] isEqualToString:@"coursework_reminder"]){
            
            [self displayCourseworkItemWithId:[userInfo objectForKey:@"coursework_id"]];
            
        }
    }
}

-(void)createNotificationWithMessage:(NSString *)message{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    Notification* notification = [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:context];
    
    notification.message = message;
    
    notification.received = [NSDate date];
    
    notification.read = [NSNumber numberWithBool:NO];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsUpdate" object:nil];
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        
        NSNumber *badge_count = [[NSUserDefaults standardUserDefaults] objectForKey:@"badge_count"];
        
        badge_count = [NSNumber numberWithInt:([badge_count intValue] + 1)];
    
        [self updateBadge];
    }
    
}

-(void)updateBadge{
    
    NSNumber *badgeNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"badge_count"];
    
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[badgeNumber integerValue]];
    
}

-(void)displayCourseworkItemWithId:(NSNumber *)coursework_id{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coursework"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"coursework_id == %@", coursework_id];
    
    NSError *error = nil;
    
    NSArray *items = [context executeFetchRequest:request error:&error];
    
    UIViewController *root = self.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CourseworkDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"courseworkModal"];
    
    CourseworkModalViewController *cmvc = [vc.childViewControllers objectAtIndex:0];
    cmvc.coursework = [items objectAtIndex:0];
    
    [root presentViewController:vc animated:YES completion:nil];
    
}

-(void)displayEventItemWithId:(NSNumber *)event_id{
        
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"event_id == %@", event_id];
    
    NSError *error = nil;
    
    NSArray *items = [context executeFetchRequest:request error:&error];
    
    UIViewController *root = self.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    EventModalViewController *emvc = [storyboard instantiateViewControllerWithIdentifier:@"eventModal"];
    
    EventDetailsViewController *edvc = [emvc.childViewControllers objectAtIndex:0];
    edvc.event = [items objectAtIndex:0];
    
    [root presentViewController:emvc animated:YES completion:nil];

}

-(void)displayPostItemWithId:(NSNumber *)post_id{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Posts"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"post_id == %@", post_id];
    
    NSError *error = nil;
    
    if([context countForFetchRequest:request error:&error]){
        
        NSArray *items = [context executeFetchRequest:request error:&error];
        
        UIViewController *root = self.window.rootViewController;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UINavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"postModal"];

        PostModalViewController *pmvc = [nc.childViewControllers objectAtIndex:0];
        
        pmvc.post = [items objectAtIndex:0];
        
        
        [root presentViewController:nc animated:YES completion:nil];
        
    }
    
    
}

@end
