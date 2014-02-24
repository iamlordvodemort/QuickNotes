//
//  NSString+Compare.m
//  quicknote
//
//  Created by Anthony Layne on 2/10/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import "NSString+Compare.h"

@implementation NSString (Compare)



#pragma mark - Validation Check Methods

+ (BOOL)stringIsValidEmail:(NSString *)checkString {
    
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (BOOL)stringContainsOneLetter:(NSString*)checkString {
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"[a-zA-Z]" options:0 error:NULL];
    NSUInteger matches = [regex numberOfMatchesInString:checkString options:0 range:NSMakeRange(0, [checkString length])];
    
    if (matches > 0) {
        return YES;
    }else{
        return NO;
    }
    
}

+ (BOOL)stringContainsOneNumber:(NSString*)checkString {
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"[0-9]" options:0 error:NULL];
    
    NSUInteger matches = [regex numberOfMatchesInString:checkString options:0 range:NSMakeRange(0, [checkString length])];
    
    if (matches > 0) {
        return YES;
    }else{
        return NO;
    }
}


@end