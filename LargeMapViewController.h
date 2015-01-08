//
//  LargeMapViewController.h
//  Saint Portal
//
//  Created by David Foster on 07/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Event.h"

@interface LargeMapViewController : UIViewController
@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (nonatomic, strong) Event* event;
@end
