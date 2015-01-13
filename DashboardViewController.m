//
//  DashboardViewController.m
//  Saint Portal
//
//  Created by David Foster on 13/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "DashboardViewController.h"
#import "CourseworkDetailsViewController.h"
#import "DashboardUpcomingCourseworkTableViewController.h"
#import "DashViewController.h"

@interface DashboardViewController ()
@property (strong, nonatomic) NSArray *myViewControllers;
@property (strong, nonatomic) UIViewController *transitioningTo;
@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    
    UIViewController *p1 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"DashboardUpcomingEvents"];
    UIViewController *p2 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"DashboardUpcomingCoursework"];
    
    self.myViewControllers = @[p1, p2];
    
    [self setViewControllers:@[p1]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO completion:nil];
    
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
    NSUInteger currentIndex = [self.myViewControllers indexOfObject:viewController];
    
    if(currentIndex == 0){
        return nil;
    }else{
        --currentIndex;
        return [self.myViewControllers objectAtIndex:currentIndex];
    }
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.myViewControllers indexOfObject:viewController];
    
    if(currentIndex == 1){
        return nil;
    }else{
        ++currentIndex;
        
        return [self.myViewControllers objectAtIndex:currentIndex];
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

-(void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    
    self.transitioningTo = [pendingViewControllers firstObject];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed{
    
    if(completed){
        
        NSUInteger currentIndex = [self.myViewControllers indexOfObject:self.transitioningTo];
        
        [(DashViewController *)self.parentViewController titleForIndex:currentIndex];
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    
}

@end
