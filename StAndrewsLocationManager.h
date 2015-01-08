//
//  StAndrewsLocationManager.h
//  Saint Portal
//
//  Created by David Foster on 18/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface StAndrewsLocationManager : NSObject

-(void)setupLocationManager;

-(void)applicationEnteredForeground;

-(void)applicationEnteredBackground;

@end
