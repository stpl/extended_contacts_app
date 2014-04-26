//
//  DetailViewController.m
//  SysTelephony
//
//  Copyright (c) 2014 Systango. All rights reserved.
//

#import "DetailViewController.h"
#import "NSDictionary+hasValueForKey.h"
#import "AppDelegate.h"

@interface DetailViewController ()

@property(nonatomic, strong) NSMutableArray *telephonyList;

@end


@implementation DetailViewController

- (id)initWithTelephonyList:(NSMutableArray *)telephonyList
{
    self = [super init];
    _telephonyList = telephonyList;
    
    return self;
}

#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"History";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(dismissController)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.telephonyList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    if(self.telephonyList.count > indexPath.row)
    {
       NSDictionary *telephony = [self.telephonyList objectAtIndex:indexPath.row];
        
        NSDate *startTime = ([telephony hasValueForKey:@"StartTime"])? [telephony valueForKey:@"StartTime"]:@"";
        cell.textLabel.text = [ApplicationDelegate getDate:startTime];
        cell.detailTextLabel.text = [ApplicationDelegate getTime:startTime];
        
        //TODO will read later
        if([telephony hasValueForKey:@"Duration"])
        {
        }
    }
    
    return cell;
}

#pragma mark - Private methods

- (void)dismissController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
