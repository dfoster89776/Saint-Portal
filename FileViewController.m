//
//  FileViewController.m
//  Saint Portal
//
//  Created by David Foster on 12/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "FileViewController.h"

@interface FileViewController () <UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;
@property (strong, nonatomic) IBOutlet UILabel *documentNameLabel;
@end

@implementation FileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.documentNameLabel.text = self.file.file_name;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)previewFile:(id)sender {
    
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,   NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"Files/%@", self.file.file_id]];
    // Content_ Folder is your folder name
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath  withIntermediateDirectories:YES attributes:nil error:&error];
    NSLog(@"Creating file directory");
    //This will create a new folder if content folder is not exist
    
    NSString *fileName = [stringPath stringByAppendingFormat:@"/%@", self.file.file_name];
    
    if ((![[NSFileManager defaultManager] fileExistsAtPath:fileName]) || self.file.update_available) {
        
        NSLog(@"Downloading");
        
        NSString *str = self.file.file_url;
        
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"embed %@",str);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:str]];
        [data writeToFile:fileName atomically:YES];
        
    }

    
    if([[NSFileManager defaultManager] fileExistsAtPath:fileName]){
        NSLog(@"File exists");
    }
    
    NSURL *URL = [NSURL fileURLWithPath:fileName];
    
    NSLog(@"Opening url: %@", URL);
    
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
