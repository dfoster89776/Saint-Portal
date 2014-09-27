//
//  SetupViewController.m
//  Saint Portal
//
//  Created by David Foster on 23/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "SetupViewController.h"
#import "SetupPersonalDetails.h"

@interface SetupViewController ()
@property (nonatomic) BOOL personalDetailsStatus;
@property (nonatomic, strong) SetupPersonalDetails* personalDetails;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *personalDetailsActivityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *personalDetailsCheckmark;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@end

@implementation SetupViewController
@synthesize personalDetails;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateForeground:)
                                                 name: UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    self.personalDetails = [[SetupPersonalDetails alloc]init];
    [self.personalDetails setSetupController:self];
}


-(void)updateForeground:(id)not{
   
}

-(void)updateStatus{
    
    NSLog(@"Updating status");
    
    //Personal Details
    self.personalDetailsStatus = [self.personalDetails getStatus];
    
    if(self.personalDetailsStatus){
        [self.personalDetailsActivityIndicator stopAnimating];
        self.personalDetailsActivityIndicator.hidden = YES;
        self.personalDetailsCheckmark.hidden = NO;
    }
    
    if(self.personalDetailsStatus){
        self.continueButton.hidden = NO;
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
