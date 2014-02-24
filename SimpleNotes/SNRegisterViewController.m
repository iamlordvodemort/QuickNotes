//
//  SNRegisterViewController.m
//  quicknote
//
//  Created by Anthony Layne on 2/10/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import "SNRegisterViewController.h"
#import "NSString+Compare.h"

@interface SNRegisterViewController ()
@end

@implementation SNRegisterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"white-back"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(cancelSignUpAction:)];
    
    self.navigationItem.leftBarButtonItem = btnBack;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

-(void)cancelSignUpAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signupAction:(id)sender
{
    
    BOOL valid = YES;
    NSString *errMsg = @"";
    
    if (![NSString stringIsValidEmail:_email.text]) {
        valid = NO;
        errMsg = NSLocalizedString(@"Please enter a valid email address.", nil);
    }else if ([_usrname.text isEqualToString:@""]) {
        valid = NO;
        errMsg = NSLocalizedString(@"Please choose a username.", nil);
    }else if (![NSString stringContainsOneLetter:_passwrd.text] || ![NSString stringContainsOneNumber:_passwrd.text]) {
        valid = NO;
        errMsg = NSLocalizedString(@"For security, your password MUST contain atleast one letter and one number.", nil);
    }
    
    if (valid) {
        
        PFUser *user = [PFUser user];
        user.username = _usrname.text;
        user.password = _passwrd.text;
        user.email = _email.text;
        
        // other fields can be set just like with PFObject
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now.
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                // Show the errorString somewhere and let the user try again.
                NSString *errorString = NSLocalizedString([error userInfo][@"error"], nil);
                NSLog(@"error: %@", errorString);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Log In Error", nil)
                                                                message:errorString
                                                               delegate:nil
                                                      cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss",nil), nil];
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
        [self.email becomeFirstResponder];
    }else if (textField == self.email) {
        [self.passwrd becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        [self signupAction:self];
    }
    
    return YES;
}

@end
