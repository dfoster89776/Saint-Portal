//
//  SetupViewController.m
//  Saint Portal
//
//  Created by David Foster on 23/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "SetupViewController.h"
#import "UpdatePersonalDetailsHandler.h"
#import <EventKit/EventKit.h>
#import "AppDelegate.h"
#import "CalendarHandler.h"
#import "UpdateAllModuleData.h"


@interface SetupViewController () <UpdateAllModuleDataDelegate>
@property (nonatomic) BOOL personalDetailsStatus;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *personalDetailsActivityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *personalDetailsCheckmark;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *moduleDetailsActivityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *moduleDetailsCheckmark;


@property (strong, nonatomic) UpdatePersonalDetailsHandler *updatePersonalDetailsHandler;
@property (strong, nonatomic) UpdateAllModuleData *updateModuleDataHandler;

@property (nonatomic) BOOL moduleData;
@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.moduleData = false;
}

-(void)viewDidAppear:(BOOL)animated{
    
        [CalendarHandler setupCalendar];

        //Update personal details
        self.updatePersonalDetailsHandler = [[UpdatePersonalDetailsHandler alloc] init];
        [self.updatePersonalDetailsHandler UpdatePersonalDetailsWithDelegate:self];
    
        self.updateModuleDataHandler = [[UpdateAllModuleData alloc] init];
        [self.updateModuleDataHandler updateAllModuleDataWithDelegate:self];
    
}

-(void)updateStatus{
    
    
    //Check status of personal details setup
    BOOL personal = [self.updatePersonalDetailsHandler getStatus];
    
    if(personal){
        [self.personalDetailsActivityIndicator stopAnimating];
        self.personalDetailsCheckmark.hidden = NO;
    }
    
    if(self.moduleData){
        [self.moduleDetailsActivityIndicator stopAnimating];
        self.moduleDetailsCheckmark.hidden = NO;
    }
    
    if(personal && self.moduleData){
        
        self.continueButton.hidden = NO;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:[NSString stringWithFormat:@"true"] forKey:@"setup_complete"];
    }
    
}

-(void)APIErrorHandler:(NSError *)error{
    
    NSLog(@"Error Occcured");
    
}

-(void)updateAllModuleDataSuccess{
    self.moduleData = true;
    [self updateStatus];
}

-(void)updateAllModuleDataFailure:(NSError *)error{
    self.moduleData = true;
    [self updateStatus];
}

@end
