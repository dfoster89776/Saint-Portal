//
//  PostModalViewController.m
//  Saint Portal
//
//  Created by David Foster on 13/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "PostModalViewController.h"
#import "PostViewController.h"

@interface PostModalViewController ()

@end

@implementation PostModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeModal:(id)sender {

    [self.parentViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"postEmbed"]){
        
        PostViewController *pvc = segue.destinationViewController;
        
        pvc.post = self.post;
        
    }
    
}


@end
