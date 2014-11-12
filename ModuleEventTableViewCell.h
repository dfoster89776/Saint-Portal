//
//  ModuleEventTableViewCell.h
//  Saint Portal
//
//  Created by David Foster on 26/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface ModuleEventTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (strong, nonatomic) IBOutlet UILabel *eventModuleLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventStartTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventEndTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventRoomLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventBuildingLabel;
@end
