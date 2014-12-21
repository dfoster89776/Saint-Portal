//
//  CourseworkDetailsViewController.m
//  Saint Portal
//
//  Created by David Foster on 29/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "CourseworkDetailsViewController.h"
#import "File.h"
#import "OpenStoreHandler.h"
#import "Specification.h"
#import "Feedback.h"

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
@property (strong, nonatomic) IBOutlet UIButton *viewOtherFilesButton;
@property (strong, nonatomic) IBOutlet UIView *submissionContainerView;
@property (strong, nonatomic) IBOutlet UIView *feedbackContainerView;
@property (strong, nonatomic) UIDocumentInteractionController* documentInteractionController;
@property (strong, nonatomic) IBOutlet UIView *noFeedbackContainer;
@property (strong, nonatomic) IBOutlet UIView *yesFeedbackContainer;
@property (strong, nonatomic) IBOutlet UILabel *gradeAchieved;
@property (strong, nonatomic) IBOutlet UILabel *feedbackDate;
@property (strong, nonatomic) IBOutlet UITextView *feedbackComments;
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

    UIView *topBorder = [UIView new];
    topBorder.backgroundColor = UIColorFromRGB(0x00AEEF);
    topBorder.frame = CGRectMake(0, 0, self.submissionContainerView.frame.size.width, 1);
    [self.submissionContainerView addSubview:topBorder];
    
    UIView *topBorder2 = [UIView new];
    topBorder2.backgroundColor = UIColorFromRGB(0x00AEEF);
    topBorder2.frame = CGRectMake(0, 0, self.feedbackContainerView.frame.size.width, 1);
    [self.feedbackContainerView addSubview:topBorder2];
    
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
    
    if(!self.coursework.coursework_directory){
        
        [self.viewOtherFilesButton removeFromSuperview];
        
    }
    
    if([self.coursework.feedback_received boolValue]){
        NSLog(@"Feedback available");
        [self.noFeedbackContainer removeFromSuperview];
        self.gradeAchieved.text = [NSString stringWithFormat:@"%@", self.coursework.feedback.grade];
        self.feedbackComments.text = self.coursework.feedback.comment;
        [self.feedbackComments sizeToFit];
        [self.feedbackComments layoutIfNeeded];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm dd/MM/yyyy"];
        self.feedbackDate.text = [df stringFromDate:self.coursework.feedback.received];
        
    }else{
        NSLog(@"No Feedback available");
        [self.yesFeedbackContainer removeFromSuperview];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewCourseworkFile:(UIButton *)sender {
    
    NSLog(@"Opening file: %@", self.coursework.specification.file_url);
    
    File* file = (File *)self.coursework.specification;
    
    OpenStoreHandler *osh = [[OpenStoreHandler alloc] init];
    [osh openFile:file withCurrentView:self];
    
}

- (IBAction)viewCourseworkDirectory:(id)sender {

    Directory *directory = (Directory *)self.coursework.coursework_directory;
    
    OpenStoreHandler *osh = [[OpenStoreHandler alloc] init];
    [osh openDirectory:directory withCurrentView:self];
    

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
