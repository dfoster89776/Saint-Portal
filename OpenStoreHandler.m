//
//  OpenStoreHandler.m
//  Saint Portal
//
//  Created by David Foster on 12/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "OpenStoreHandler.h"
#import "File.h"
#import "FileViewController.h"
#import <UIKit/UIKit.h>
#import "DirectoryTableViewController.h"

@interface OpenStoreHandler ()

@end

@implementation OpenStoreHandler

-(void)openFile:(File*)file withCurrentView:(UIViewController *)current{
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        FileViewController *fvc = [storyboard instantiateViewControllerWithIdentifier:@"fileView"];
        fvc.file = file;
        [current.navigationController pushViewController:fvc animated:YES];
        
  
}


-(void)openDirectory:(Directory*)directory withCurrentView:(UIViewController *)current{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DirectoryTableViewController *dtvc = [storyboard instantiateViewControllerWithIdentifier:@"directoryView"];
    dtvc.directory = directory;
    [current.navigationController pushViewController:dtvc animated:YES];
    
    
}

@end
