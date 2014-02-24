//
//  SNLoginViewController.m
//  SimpleNotes
//
//  Created by Anthony Layne on 2/10/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import "SNLoginViewController.h"
#import "SNRegisterViewController.h"
#import "SNUser.h"
#import "NSString+Compare.h"


@interface SNLoginViewController ()
@end

@implementation SNLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = NSLocalizedString(@"Log In", nil);
    _usrname.placeholder = NSLocalizedString(@"username", nil);
    _usrname.text = @"";
    _passwd.placeholder = NSLocalizedString(@"password", nil);
    _passwd.text = @"";
    
    [_btnForgotPwd setTitle:NSLocalizedString(@"Forgot your password ?", nil) forState:UIControlStateNormal];
   
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"white-back"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(goBackAction:)];
    
    self.navigationItem.leftBarButtonItem = btnBack;
}

- (void)setButtonTitles
{
}

-(void)resetView
{
    _loginLoadingView.hidden = YES;
}

- (void)goBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginAction:(id)sender
{
    BOOL valid = YES;
    NSString *errMsg = @"";
    
    if ([_usrname.text isEqualToString:@""] || [_passwd.text isEqualToString:@""]) {
        valid = NO;
        errMsg = NSLocalizedString(@"You must enter both a user name and password to sign in.", nil);
        
    }else if (![NSString stringIsValidEmail:_usrname.text]) {
        
        valid = NO;
        errMsg = NSLocalizedString(@"Please enter a valid email address.", nil);
    }
    
   if (valid) {
       
       [PFUser logInWithUsernameInBackground:_usrname.text
                                    password:_passwd.text
                                       block:^(PFUser *user, NSError *error) {
                                           
                                            if (user) {
                                                // Do stuff after successful login.
                                                NSLog(@"%@", user);
                                                SNUser *currentUser = [[SNUser sharedInstance]initWithUser:user];
                                                [currentUser setFbLogin:NO];
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                            } else {
                                                // The login failed. Check error to see why.
                                                NSString *errorString = NSLocalizedString([error userInfo][@"error"], nil);
                                                NSLog(@"error: %@", errorString);
                                                
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Log In Error", nil)
                                                                                                message:errorString
                                                                                               delegate:nil
                                                                                      cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil];
                                                [alert show];
                                            }
                                        }];
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Log In Error", nil)
                                                        message:errMsg
                                                       delegate:nil
                                              cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss",nil), nil];
        [alert show];
    }
}

#pragma mark - UITextField Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usrname) {
        [self.passwd becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        [self loginAction:self];
    }
    
    return YES;
}

- (IBAction)forgotPasswordAction:(id)sender {
    
    if (![_usrname.text isEqualToString:@""] && ![NSString stringIsValidEmail:_usrname.text]) {
        [PFUser requestPasswordResetForEmailInBackground:_usrname.text];
    }else {
        NSString *errMsg = NSLocalizedString(@"Please enter a valid email address.", nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:errMsg
                                                       delegate:nil
                                              cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil];
        [alert show];
    }
}

@end
