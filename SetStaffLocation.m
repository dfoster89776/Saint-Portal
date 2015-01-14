//
//  SetStaffLocation.m
//  Saint Portal
//
//  Created by David Foster on 11/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "SetStaffLocation.h"
#import "UpdateLocationsHandler.h"
#import "AppDelegate.h"
#import "Rooms.h"
#import "Staff.h"
#import <AddressBook/AddressBook.h>

@interface SetStaffLocation () <UpdateLocationsDelegate>
@property (nonatomic, strong)NSManagedObjectContext* context;
@property (nonatomic) int location_id;
@property (nonatomic, strong) Staff* staff;
@property (nonatomic) ABAddressBookRef addressBookRef;
@end

@implementation SetStaffLocation

-(void)setLocationForStaff:(Staff *)staff withLocationID:(int)location_id{
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.location_id = location_id;
    self.staff = staff;
    
    NSError* error;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Rooms"];
    request.predicate = [NSPredicate predicateWithFormat:@"location_id == %i", location_id];
    
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    
    if(count == 0){
        
        UpdateLocationsHandler *ulh = [[UpdateLocationsHandler alloc] init];
        [ulh updateLocationsLibraryWithDelegate:self];
        
    }else{
        
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        Rooms* location = [result firstObject];
        
        [self setStaffLocation:location];
    }
    
}


-(void)callback{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Rooms"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"location_id == %i", self.location_id];
    
    NSError *error = nil;
    
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    Rooms* location = [result firstObject];
    
    [self setStaffLocation:location];

    
}

-(void)setStaffLocation:(Rooms *)room{
    
    self.staff.office_location = room;
        
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
    [self updateContact];
}

-(void)updateContact{
    
    //Get authorisation to access address book
    self.addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                [self updateContactCard];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self updateContactCard];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    
    
}

-(void)updateContactCard{
    
    ABRecordRef newPerson;
    CFErrorRef error;
    
    if([self.staff.record_id intValue] == 0){
    
        newPerson = ABPersonCreate();
        ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFStringRef)self.staff.firstname, &error);
        ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFStringRef)self.staff.surname, &error);
        NSLog(@"No record exists");
        
        ABAddressBookAddRecord(self.addressBookRef, newPerson, &error);
        
        ABAddressBookSave(self.addressBookRef, &error);
        
        NSLog(@"Record id: %d", ABRecordGetRecordID(newPerson));
        
        self.staff.record_id = [NSNumber numberWithInt:ABRecordGetRecordID(newPerson)];
        
        NSLog(@"Record id set as: %@", self.staff.record_id);
        
        CFRelease(newPerson);
        
    }else{
        
        newPerson = ABAddressBookGetPersonWithRecordID(self.addressBookRef, [self.staff.record_id intValue]);
        
        ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFStringRef)self.staff.firstname, &error);
        ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFStringRef)self.staff.surname, &error);
        NSLog(@"Record exists");
        
        ABAddressBookAddRecord(self.addressBookRef, newPerson, &error);
        
        ABAddressBookSave(self.addressBookRef, &error);
        
        self.staff.record_id = [NSNumber numberWithInt:ABRecordGetRecordID(newPerson)];
        
        CFRelease(newPerson);
        
    }
 
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
}



@end
