//
//  SNUser.m
//  quicknote
//
//  Created by Anthony Layne on 2/19/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import "SNUser.h"

@implementation SNUser
static SNUser* sharedInstance;

+ (SNUser*)sharedInstance
{
    @synchronized(self) {
        
        if (!sharedInstance) {
            sharedInstance = [[SNUser alloc] init];
        }
    }
    return sharedInstance;
}

- (id)initWithUser:(PFUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
        self.friendsArray = @[];
        self.notesArray = @[];
    }
    
    return self;
}

@end
