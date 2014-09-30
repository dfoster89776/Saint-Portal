//
//  SetupViewController.m
//  Saint Portal
//
//  Created by David Foster on 23/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "SetupViewController.h"
#import "UpdatePersonalDetailsHandler.h"

@interface SetupViewController ()
@property (nonatomic) BOOL personalDetailsStatus;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *personalDetailsActivityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *personalDetailsCheckmark;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;

@property (strong, nonatomic) UpdatePersonalDetailsHandler *updatePersonalDetailsHandler;
@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateForeground:)
                                                 name: UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    
    //Update personal details
    self.updatePersonalDetailsHandler = [[UpdatePersonalDetailsHandler alloc] init];
    [self.updatePersonalDetailsHandler UpdatePersonalDetailsWithDelegate:self];
    
    
    
}


-(void)updateForeground:(id)not{
   
}

-(void)updateStatus{
    
    //Check status of personal details setup
    BOOL personal = [self.updatePersonalDetailsHandler getStatus];
    
    if(personal){
        [self.personalDetailsActivityIndicator stopAnimating];
        self.personalDetailsCheckmark.hidden = NO;
    }
    
    if(personal){
        self.continueButton.hidden = NO;
    }
    
    
    NSLog(@"Setup delegate called");
    
}

@end
