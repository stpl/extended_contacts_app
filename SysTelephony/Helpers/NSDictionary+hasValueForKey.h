//
//  NSDictionary+hasValueForKey.h
//  Veromuse
//
//  Copyright (c) 2014 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary_hasValueForKey : NSDictionary



@end

@interface NSDictionary (HasValueForKey)

- (BOOL)hasValueForKey:(NSString *)key;

@end
