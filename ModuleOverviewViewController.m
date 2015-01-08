//
//  ModuleOverviewViewController.m
//  Saint Portal
//
//  Created by David Foster on 16/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "ModuleOverviewViewController.h"

@interface ModuleOverviewViewController ()
@property (strong, nonatomic) IBOutlet UILabel *moduleCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *moduleNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *moduleSemesterLabel;
@property (strong, nonatomic) IBOutlet UILabel *moduleYearLabel;
@property (strong, nonatomic) IBOutlet UIView *modulePeriodView;
@property (strong, nonatomic) IBOutlet UITextView *moduleDescriptionTextView;

@end

@implementation ModuleOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moduleCodeLabel.text = self.module.module_code;
    self.moduleNameLabel.text = self.module.module_name;
    self.moduleSemesterLabel.text = self.module.semester;
    self.moduleYearLabel.text = self.module.year;
    
    UIView *leftBorder = [UIView new];
    leftBorder.backgroundColor = [UIColor whiteColor];
    leftBorder.frame = CGRectMake(0, 0, 1, self.modulePeriodView.frame.size.height);
    [self.modulePeriodView addSubview:leftBorder];
    
    self.moduleDescriptionTextView.text = self.module.module_description;
    [self.moduleDescriptionTextView setFont:[UIFont systemFontOfSize:16]];
    [self.moduleDescriptionTextView sizeToFit];
    [self.moduleDescriptionTextView layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showModuleStaff:(id)sender {

    [self.parentViewController.parentViewController performSegueWithIdentifier:@"showModuleStaff" sender:self];

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
