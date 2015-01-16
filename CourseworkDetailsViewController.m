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
#import "CourseworkSubmissionHandler.h"
#import "Submission.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

@interface CourseworkDetailsViewController () <UIDocumentInteractionControllerDelegate, UIDocumentPickerDelegate, CourseworkSubmissionDelegate>
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
@property (strong, nonatomic) IBOutlet UILabel *submissionDeadlinePassedLabel;
@property (strong, nonatomic) IBOutlet UIButton *makeSubmissionButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *uploadActivityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *uploadStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *submissionStatusLabel;
@property (strong, nonatomic) IBOutlet UIButton *viewSubmissionButton;
@end

@implementation CourseworkDetailsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"courseworkUpdate" object:nil];
    
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
    
    [self updateView:nil];
    
}

-(void)updateView:(NSNotification*) notification{
    
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
    
    //Submission
    if([self.coursework.submitted boolValue]){
        
        self.submissionStatusLabel.hidden = true;
        self.viewSubmissionButton.hidden = false;
        
        NSDate *now = [[NSDate alloc] init];
        NSDate *due = self.coursework.coursework_due;
        
        if([now compare:due] == NSOrderedAscending) {
            self.submissionDeadlinePassedLabel.hidden = YES;
            [self.makeSubmissionButton setTitle:@"Update Submission" forState:UIControlStateNormal];
        }else{
            
            self.makeSubmissionButton.hidden = YES;
        }
    }else{
        
        self.submissionDeadlinePassedLabel.hidden = YES;
        
    }
    
    
    //Feedback
    if([self.coursework.feedback_received boolValue]){
        self.noFeedbackContainer.hidden = YES;
        self.gradeAchieved.text = [NSString stringWithFormat:@"%@", self.coursework.feedback.grade];
        self.feedbackComments.text = self.coursework.feedback.comment;
        [self.feedbackComments sizeToFit];
        [self.feedbackComments layoutIfNeeded];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm dd/MM/yyyy"];
        self.feedbackDate.text = [df stringFromDate:self.coursework.feedback.received];
        
    }else{
        NSLog(@"No Feedback available");
        self.yesFeedbackContainer.hidden = YES;
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
- (IBAction)viewSubmissionFile:(id)sender {
    
    File* file = (File *)self.coursework.submission;
    
    OpenStoreHandler *osh = [[OpenStoreHandler alloc] init];
    [osh openFile:file withCurrentView:self];
}

- (IBAction)viewCourseworkDirectory:(id)sender {

    Directory *directory = (Directory *)self.coursework.coursework_directory;
    
    OpenStoreHandler *osh = [[OpenStoreHandler alloc] init];
    [osh openDirectory:directory withCurrentView:self];
    

}

- (IBAction)openDocumentPicker:(id)sender {
    
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.item"]
                                                                                                            inMode:UIDocumentPickerModeImport];
    
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
    
}

-(IBAction)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url{
    
    NSLog(@"URL: %@", url);
    
    [self.makeSubmissionButton setHidden:true];
    [self.uploadActivityIndicator startAnimating];
    
    CourseworkSubmissionHandler* csh = [[CourseworkSubmissionHandler alloc] init];
    
    [csh submitCourseworkForItem:self.coursework withFile:url withDelegate:self];
    
    
}

-(void)CourseworkUploadSuccess{
    
    [self.uploadActivityIndicator stopAnimating];
    self.uploadStatusLabel.text = @"Successfully Uploaded";
    [self.uploadStatusLabel setHidden:false];
    
    [self.uploadStatusLabel setHidden:true];
    [self.makeSubmissionButton setHidden:false];
    [self.viewSubmissionButton setHidden:false];
    [self.submissionStatusLabel setHidden:true];
    
}

-(void)CourseworkUploadFailure{
    
    [self.uploadActivityIndicator stopAnimating];
    self.uploadStatusLabel.text = @"Failed to Upload.";
    [self.uploadStatusLabel setHidden:false];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.uploadStatusLabel setHidden:true];
        [self.makeSubmissionButton setHidden:false];
    });
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
