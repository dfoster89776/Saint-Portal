//
//  CalendarHandler.h
//  Saint Portal
//
//  Created by David Foster on 04/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface CalendarHandler : NSObject

+(BOOL)setupCalendar;
+(BOOL)addEventToCalendar:(Event *)event;
+(BOOL)deleteEventFromCalendar:(Event *)deleteEvent;

@end
