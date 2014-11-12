//
//  ModalViewController.m
//  Saint Portal
//
//  Created by David Foster on 11/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "CourseworkModalViewController.h"
#import "CourseworkDetailsViewController.h"
#import "Modules.h"

@interface CourseworkModalViewController ()

@end

@implementation CourseworkModalViewController

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
    
    if([segue.identifier isEqualToString:@"CourseworkModalEmbed"]){
        
        NSLog(@"Coursework embed");
        
        CourseworkDetailsViewController *destination = segue.destinationViewController;
        
        destination.coursework = self.coursework;
        self.title = self.coursework.assignments_module.module_code;
        
    }
    
}


@end
