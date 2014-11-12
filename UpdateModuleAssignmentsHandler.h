//
//  UpdateModuleAssignmentsHandler.h
//  Saint Portal
//
//  Created by David Foster on 15/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Modules.h"

@interface UpdateModuleAssignmentsHandler : NSObject

-(id)initWithModule:(Modules*)module UsingContext:(NSManagedObjectContext *)context;

-(void)updateModulesAssignment;

@end
