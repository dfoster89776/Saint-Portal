//
//  CourseworkDetailsViewController.m
//  Saint Portal
//
//  Created by David Foster on 29/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "CourseworkDetailsViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

@interface CourseworkDetailsViewController () <UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *courseworkNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseworkToGoUnitLabel;
@property (strong, nonatomic) IBOutlet UIView *courseworkStatusView;
@property (strong, nonatomic) IBOutlet UILabel *courseworkToGoValueLabel;

@property (strong, nonatomic) IBOutlet UILabel *courseworkDueDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseworkFeedbackDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseworkWeightingLabel;

@property (strong, nonatomic) IBOutlet UIView *overviewView;
@property (strong, nonatomic) IBOutlet UITextView *courseworkDescriptionTextView;

@property (strong, nonatomic) UIDocumentInteractionController* documentInteractionController;
@end

@implementation CourseworkDetailsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *leftBorder = [UIView new];
    leftBorder.backgroundColor = [UIColor whiteColor];
    leftBorder.frame = CGRectMake(0, 0, 1, self.courseworkStatusView.frame.size.height);
    [self.courseworkStatusView addSubview:leftBorder];

    
    UIView *bottomBorder = [UIView new];
    bottomBorder.backgroundColor = UIColorFromRGB(0x00AEEF);
    bottomBorder.frame = CGRectMake(0, self.overviewView.frame.size.height, self.overviewView.frame.size.width, 1);
    [self.overviewView addSubview:bottomBorder];

    
    self.courseworkNameLabel.text = self.coursework.coursework_name;
    
    if(!self.coursework.submitted.intValue){
        
        NSDate *now = [NSDate date];
        NSDate *due = self.coursework.coursework_due;
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *difference = [calendar components:(NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:now toDate:due options:0];
                
        if([difference day] > 0){
            
            self.courseworkToGoValueLabel.text = [NSString stringWithFormat:@"%lu", [difference day]];
            self.courseworkToGoUnitLabel.text = @"Days";
            
        }else{
            
            if([difference hour] > 0){
                
                self.courseworkToGoValueLabel.text = [NSString stringWithFormat:@"%lu", [difference hour]];;
                
                self.courseworkToGoUnitLabel.text = @"Hours";
                
            }else{
                
                if([difference minute] > 0){
                    self.courseworkToGoValueLabel.text = [NSString stringWithFormat:@"%lu", [difference minute]];;
                    self.courseworkToGoUnitLabel.text = @"Minutes";
                }
                else{
                    
                    self.courseworkToGoValueLabel.text = @"!";;
                    self.courseworkToGoUnitLabel.text = @"OVERDUE";
                    
                }
                
            }
        }
    }
    
    self.courseworkWeightingLabel.text = [NSString stringWithFormat:@"%@%%", self.coursework.coursework_weighting];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm EEE dd/MM/yyyy"];
    
    self.courseworkDueDateLabel.text = [df stringFromDate:self.coursework.coursework_due];
    
    self.courseworkFeedbackDateLabel.text = [df stringFromDate:self.coursework.coursework_feedback_date];

    
    self.courseworkDescriptionTextView.text = self.coursework.coursework_description;
    [self.courseworkDescriptionTextView setFont:[UIFont systemFontOfSize:15]];
    
    [self.courseworkDescriptionTextView sizeToFit];
    [self.courseworkDescriptionTextView layoutIfNeeded];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewCourseworkFile:(UIButton *)sender {
    
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,   NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Coursework_Folder"];
    // Content_ Folder is your folder name
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath  withIntermediateDirectories:NO attributes:nil error:&error];
    //This will create a new folder if content folder is not exist
    
    NSString *fileName = [stringPath stringByAppendingFormat:@"/cwk_1.pdf"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileName]) {

        NSLog(@"Downloading");
        
        NSString *str = self.coursework.coursework_file;
        
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"embed %@",str);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:str]];
        [data writeToFile:fileName atomically:YES];

    }

    NSURL *URL = [NSURL fileURLWithPath:fileName];
    
    if (URL) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];
        
        self.documentInteractionController.name = @"Specification";
        
        // Preview PDF
        [self.documentInteractionController presentPreviewAnimated:YES];
    }
    
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
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
