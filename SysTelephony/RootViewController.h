//
//  ViewController.h
//  SysTelephony
//
//  Copyright (c) 2014 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface RootViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, MFMessageComposeViewControllerDelegate>

@end
