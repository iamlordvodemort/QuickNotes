//
//  SNUser.h
//  quicknote
//
//  Created by Anthony Layne on 2/19/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFUser;

@interface SNUser : NSObject
/*
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *emailAddress;
*/
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSArray *friendsArray;
@property (nonatomic, strong) NSArray *notesArray;

@property (nonatomic) BOOL fbLogin;

+ (SNUser *)sharedInstance;
- (id)initWithUser:(PFUser *)user;

@end
