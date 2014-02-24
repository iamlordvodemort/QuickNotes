//
//  NSString+Compare.h
//  quicknote
//
//  Created by Anthony Layne on 2/10/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Compare)

+ (BOOL)stringIsValidEmail:(NSString *)checkString;
+ (BOOL)stringContainsOneLetter:(NSString*)checkString;
+ (BOOL)stringContainsOneNumber:(NSString*)checkString;

@end
