//
//  PostSlidesTableViewController.h
//  Saint Portal
//
//  Created by David Foster on 11/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Slides.h"
#import "Posts.h"

@interface PostSlidesTableViewController : UITableViewController
@property (strong, nonatomic) Posts* post;
@end
