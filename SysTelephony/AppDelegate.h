//
//  AppDelegate.h
//  SysTelephony
//
//  Copyright (c) 2014 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *rootViewController;

- (NSString *)getDate:(NSDate *)date;
- (NSString *)getTime:(NSDate *)date;

@end
