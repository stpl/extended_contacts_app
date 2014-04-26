//
//  ViewController.m
//  SysTelephony
//
//  Copyright (c) 2014 Systango. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "NSDictionary+hasValueForKey.h"
#import "NSString+Properties.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@interface RootViewController ()

@property (nonatomic, strong) NSMutableDictionary *contactInfoDict;
@property (nonatomic, strong) NSMutableArray *selectedContactsData;
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *callTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *detailCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *phoneCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *messageCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *historyCell;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Details";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Contacts" style:UIBarButtonItemStyleDone target:self action:@selector(showAddressBook)];
    
    [self showAddressBook];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private method implementation

-(void)showAddressBook{
    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [_addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:_addressBookController animated:YES completion:nil];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
    {
        case 0 :
        {
            NSData *imageData = [self.contactInfoDict hasValueForKey:@"image"]?[self.contactInfoDict objectForKey:@"image"]:nil;
            if(imageData)
            {
                UIImage *image = [UIImage imageWithData:imageData];
                [self.imageButton setImage:image forState:UIControlStateNormal];
            }
            
            NSString *name;
            if([self.contactInfoDict hasValueForKey:@"firstName"])
                name = [self.contactInfoDict valueForKey:@"firstName"];
            if([self.contactInfoDict hasValueForKey:@"lastName"])
                [name append:[self.contactInfoDict valueForKey:@"lastName"]];
            
            self.navigationItem.title = [name append:@" Details"];
                self.nameLabel.text = name;
        }
            return self.detailCell;
        case 1:
        {
            self.phoneNumberLabel.text = [self getPhoneNumber];
        }
            return  self.phoneCell;
        case 2:
            return  self.messageCell;
        default:
        {
            NSDictionary *telephony = nil;
            if(self.selectedContactsData.count)
            {
                telephony = [self.selectedContactsData lastObject];
                
                NSNumber *state = ([telephony hasValueForKey:@"State"])? [telephony valueForKey:@"State"]:@"";
                NSNumber *duration = ([telephony hasValueForKey:@"Duration"])? [telephony valueForKey:@"Duration"]:@"";
                NSDate *startTime = ([telephony hasValueForKey:@"StartTime"])? [telephony valueForKey:@"StartTime"]:@"";
                
                self.durationLabel.text = [NSString stringWithFormat:@"%d", [duration integerValue]];
                self.callTypeLabel.text = [state integerValue]==1?@"Outgoing calls":@"";
                self.dateLabel.text = [ApplicationDelegate getDate:startTime];
                self.timeLabel.text = [ApplicationDelegate getTime:startTime];
            }
        }
            return self.historyCell;
    }
}

#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
    {
        case 0 :
            return self.detailCell.frame.size.height;
        case 1:
            return  self.phoneCell.frame.size.height;
        case 2:
            return  self.messageCell.frame.size.height;
        default:
            return self.historyCell.frame.size.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row)
    {
        case 1:
            [self makeCall];
            break;
        case 2:
            [self sendSMS];
            break;
        case 3:
            [self showDetails];
            break;
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller

                 didFinishWithResult:(MessageComposeResult)result

{
    // Notifies users about errors associated with the interface
    switch (result)
    {
            
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultSent:
            break;
        case MessageComposeResultFailed:
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - Private methods

-(void)makeCall
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        
        NSString *phone = [[self.phoneNumberLabel.text componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]]];//130-032-2837
        
        [self didCallPerform];
        
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
}


-(void)sendSMS
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"";
        controller.recipients = [NSArray arrayWithObjects:self.phoneNumberLabel.text, nil];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

-(void)showDetails
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithTelephonyList:self.selectedContactsData];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: detailViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

- (NSString *)getPhoneNumber
{
    NSString *phoneNumber = @"";
    if([self.contactInfoDict hasValueForKey:@"homeNumber"])
        phoneNumber = [self.contactInfoDict valueForKey:@"homeNumber"];
    if(phoneNumber.trim.length == 0 && [self.contactInfoDict hasValueForKey:@"mobileNumber"])
        phoneNumber = [self.contactInfoDict valueForKey:@"mobileNumber"];
    
    return phoneNumber;
}

- (NSMutableArray *)fetchDetailsByPhone:(NSString *)selectedPhone
{
    NSMutableArray *selectedRecords = [NSMutableArray array];
    NSMutableArray *allRecords = [self fetchDetails];
    
    for (NSDictionary *telephony in allRecords)
    {
        if([telephony hasValueForKey:@"Phone"])
        {
            NSString *phone = [telephony valueForKey:@"Phone"];
            if([phone isEqualToString:selectedPhone])
            {
                [selectedRecords addObject:telephony];
            }
        }
    }
    
    return selectedRecords;
}

- (NSMutableArray *)fetchDetails
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
   
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    }
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    return array;
}

- (void)updateInfo:(NSDictionary *)telephony
{
    // First we create our array from the text retrieved from our UITextFields
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:[self fetchDetails]];
    
    [array addObject:telephony];
    
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
    
    // This writes the array to a plist file. If this file does not already exist, it creates a new one.
    [array writeToFile:plistPath atomically: TRUE];
    
}

- (void)didCallPerform
{
    NSMutableDictionary *telephony = [NSMutableDictionary dictionary];
    [telephony setValue:[NSNumber numberWithInt:1] forKey:@"State"];
    [telephony setValue:[NSNumber numberWithInt:30] forKey:@"Duration"]; //TODO will update later
    [telephony setValue:[NSDate date] forKey:@"StartTime"];
    [telephony setValue:self.phoneNumberLabel.text forKey:@"Phone"]; 
    
    [self updateInfo:telephony];
}

#pragma mark - ABPeoplePickerNavigationController Delegate method implementation

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    // Initialize a mutable dictionary and give it initial values.
    self.contactInfoDict = [[NSMutableDictionary alloc]
                                            initWithObjects:@[@"", @"", @"", @"", @"", @"", @"", @"", @""]
                                            forKeys:@[@"firstName", @"lastName", @"mobileNumber", @"homeNumber", @"homeEmail", @"workEmail", @"address", @"zipCode", @"city"]];
    
    // Use a general Core Foundation object.
    CFTypeRef generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    // Get the first name.
    if (generalCFObject) {
        [self.contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"firstName"];
        CFRelease(generalCFObject);
    }
    
    // Get the last name.
    generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (generalCFObject) {
        [self.contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"lastName"];
        CFRelease(generalCFObject);
    }
    
    // Get the phone numbers as a multi-value property.
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
            [self.contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"mobileNumber"];
        }
        
        if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            [self.contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"homeNumber"];
        }
        
        CFRelease(currentPhoneLabel);
        CFRelease(currentPhoneValue);
    }
    CFRelease(phonesRef);
    
    
    // Get the e-mail addresses as a multi-value property.
    ABMultiValueRef emailsRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    for (int i=0; i<ABMultiValueGetCount(emailsRef); i++) {
        CFStringRef currentEmailLabel = ABMultiValueCopyLabelAtIndex(emailsRef, i);
        CFStringRef currentEmailValue = ABMultiValueCopyValueAtIndex(emailsRef, i);
        
//        if (CFStringCompare(currentEmailLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
//            [self.contactInfoDict setObject:(__bridge NSString *)currentEmailValue forKey:@"homeEmail"];
//        }
        
//        if (CFStringCompare(currentEmailLabel, kABWorkLabel, 0) == kCFCompareEqualTo) {
//            [self.contactInfoDict setObject:(__bridge NSString *)currentEmailValue forKey:@"workEmail"];
//        }
        
        CFRelease(currentEmailLabel);
        CFRelease(currentEmailValue);
    }
    CFRelease(emailsRef);
    
    
    // Get the first street address among all addresses of the selected contact.
    ABMultiValueRef addressRef = ABRecordCopyValue(person, kABPersonAddressProperty);
    if (ABMultiValueGetCount(addressRef) > 0) {
        NSDictionary *addressDict = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(addressRef, 0);
        
        [self.contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressStreetKey] forKey:@"address"];
        [self.contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressZIPKey] forKey:@"zipCode"];
        [self.contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressCityKey] forKey:@"city"];
    }
    CFRelease(addressRef);
    
    
    // If the contact has an image then get it too.
    if (ABPersonHasImageData(person)) {
        NSData *contactImageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        
        [self.contactInfoDict setObject:contactImageData forKey:@"image"];
    }
    
    // Reload the table view data.
    [self.tableView reloadData];
    
    // Dismiss the address book view controller.
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
    
    if(!self.selectedContactsData)
    {
        self.selectedContactsData = [NSMutableArray array];
    }
    else
    {
        [self.selectedContactsData removeAllObjects];
    }
    
    self.selectedContactsData = [self fetchDetailsByPhone:[self getPhoneNumber]];
    
    return NO;
}


-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}


-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}
@end
