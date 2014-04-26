//
//  NSString+Properties.m
//  Veromuse
//
//  Copyright (c) 2014 Systango. All rights reserved.
//

#import "NSString+Properties.h"

@implementation NSString (Properties)

- (NSString *)append:(NSString *)appendText
{
    return [NSString stringWithFormat:@"%@%@",self, appendText];
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
