//
//  SNRegisterViewController.h
//  quicknote
//
//  Created by Anthony Layne on 2/10/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNRegisterViewController : UIViewController <UITextFieldDelegate>

#pragma mark - IBOutlets
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *usrname;
@property (strong, nonatomic) IBOutlet UITextField *passwrd;


@end
