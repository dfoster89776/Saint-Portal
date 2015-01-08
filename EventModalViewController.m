//
//  EventModalViewController.m
//  Saint Portal
//
//  Created by David Foster on 06/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "EventModalViewController.h"
#import "EventDetailsViewController.h"
#import "Modules.h"

@interface EventModalViewController ()

@end

@implementation EventModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeModalView:(id)sender {
    
    [self.parentViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"EventModalEmbed"]){
        
        EventDetailsViewController *destination = segue.destinationViewController;
        
        destination.event = self.event;
        
    }
    
}

@end
