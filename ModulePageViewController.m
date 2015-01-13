//
//  DashboardViewController.m
//  Saint Portal
//
//  Created by David Foster on 13/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "ModulePageViewController.h"
#import "ModuleCourseworkTableViewController.h"
#import "ModuleTopicsTableViewController.h"
#import "ModuleOverviewViewController.h"
#import "ModuleViewController.h"

@interface ModulePageViewController ()
@property (strong, nonatomic) NSArray *myViewControllers;
@property (nonatomic) int currentIndex;
@end

@implementation ModulePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
        
    ModuleOverviewViewController *p0 = [self.storyboard
                                           instantiateViewControllerWithIdentifier:@"Module_Overview"];
    
    ModuleTopicsTableViewController *p1 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Module_Topics"];
    ModuleCourseworkTableViewController *p2 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Module_Coursework"];
    
    p0.module = self.module;
    p1.module = self.module;
    p2.module = self.module;
    
    
    self.myViewControllers = @[p0, p1, p2];
    
    [self setViewControllers:@[p0]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES completion:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return self.myViewControllers[index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    self.currentIndex = (int)[self.myViewControllers indexOfObject:viewController];
    
    if(self.currentIndex == 0){
        return nil;
    }else{
        --self.currentIndex;
        self.currentIndex = self.currentIndex % (self.myViewControllers.count);
        return [self.myViewControllers objectAtIndex:self.currentIndex];
    }
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    self.currentIndex = (int)[self.myViewControllers indexOfObject:viewController];
 
    if(self.currentIndex == (self.myViewControllers.count - 1)){
        return nil;
    }else{
        ++self.currentIndex;
        self.currentIndex = self.currentIndex % (self.myViewControllers.count);
        return [self.myViewControllers objectAtIndex:self.currentIndex];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed{
    
    if(completed){
        
        UIViewController *currentView = [pageViewController.viewControllers objectAtIndex:0];
        
        int index = (int)[self.myViewControllers indexOfObject:currentView];
            
        [(ModuleViewController *)self.parentViewController titleForIndex:index];
    }
}

-(NSInteger)presentationCountForPageViewController:
(UIPageViewController *)pageViewController
{
    return self.myViewControllers.count;
}

-(NSInteger)presentationIndexForPageViewController:
(UIPageViewController *)pageViewController
{
    return 0;
}

@end
