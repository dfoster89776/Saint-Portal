//
//  Personal_Details.h
//  Saint Portal
//
//  Created by David Foster on 24/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Personal_Details : NSManagedObject

@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSNumber * matriculation_number;

@end
