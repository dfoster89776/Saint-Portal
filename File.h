//
//  File.h
//  Saint Portal
//
//  Created by David Foster on 12/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Store.h"


@interface File : Store

@property (nonatomic, retain) NSString * file_url;
@property (nonatomic, retain) NSNumber * file_id;

@end
