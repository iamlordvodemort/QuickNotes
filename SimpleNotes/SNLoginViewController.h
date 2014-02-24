//
//  SNLoginViewController.h
//  SimpleNotes
//
//  Created by Anthony Layne on 2/10/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNLoginViewController : UIViewController <UITextFieldDelegate>

#pragma mark - IBOutlets
@property (strong, nonatomic) IBOutlet UITextField *usrname;
@property (strong, nonatomic) IBOutlet UITextField *passwd;
@property (strong, nonatomic) IBOutlet UIView *loginLoadingView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPwd;


- (IBAction)forgotPasswordAction:(id)sender;

@end
