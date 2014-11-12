//
//  PostTableViewCell.h
//  Saint Portal
//
//  Created by David Foster on 08/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (strong, nonatomic) IBOutlet UITextView *postDescriptionTextView;

@end
