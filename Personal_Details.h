//
//  Personal_Details.h
//  Saint Portal
//
//  Created by David Foster on 21/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Personal_Details : NSManagedObject

@property (nonatomic, retain) NSString * fee_status;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * hesa_number;
@property (nonatomic, retain) NSString * matriculation_number;
@property (nonatomic, retain) NSString * student_support_number;
@property (nonatomic, retain) NSString * surname;

@end
