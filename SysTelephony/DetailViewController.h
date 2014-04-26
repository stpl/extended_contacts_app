//
//  DetailViewController.h
//  SysTelephony
//
//  Copyright (c) 2014 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *dictContactDetails;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (id)initWithTelephonyList:(NSMutableArray *)telephonyList;

@end
