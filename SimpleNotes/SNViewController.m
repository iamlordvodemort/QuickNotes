//
//  SNViewController.m
//  quicknote
//
//  Created by Anthony Layne on 2/15/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import "SNViewController.h"
#import "SNUser.h"

@interface SNViewController ()

@end

@implementation SNViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _loginLoadingView.hidden = YES;
    
    _btnFBLogin.layer.cornerRadius = 5;
    _btnRegister.layer.cornerRadius = 5;
    _btnLogin.layer.cornerRadius = 5;
    
    [_btnFBLogin setTitle:NSLocalizedString(@"Log In With Facebook", nil) forState:UIControlStateNormal];
    [_btnRegister setTitle:NSLocalizedString(@"Register With Email", nil) forState:UIControlStateNormal];
    [_btnLogin setTitle:NSLocalizedString(@"Log In", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginInWithFacebook:(id)sender {
    //get permissions
    NSArray *permissionsArray = [[NSBundle mainBundle] infoDictionary][@"Facebook Permissions"];
    //NSLog(@"permissionsArray: %@", permissionsArray);
    
    //log user in with facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray
                                    block:^(PFUser *user, NSError *error) {
                                        
                                        [_activity stopAnimating];
                                        _loginLoadingView.hidden = YES;
                                        
                                        if (!user) {
                                            if (!error) {
                                                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Log In Error", nil)
                                                                                                message:NSLocalizedString(@"Uh oh. The user cancelled the Facebook login.", nil)
                                                                                               delegate:nil
                                                                                      cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil];
                                                [alert show];
                                            } else {
                                                NSLog(@"Uh oh. An error occurred: %@", error);
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Log In Error", nil)
                                                                                                message:NSLocalizedString([error description], nil)
                                                                                               delegate:nil
                                                                                      cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss",nil), nil];
                                                [alert show];
                                            }
                                            
                                        } else {
                                            
                                            NSLog(@"%@", user);
                                            SNUser *currentUser = [[SNUser sharedInstance]initWithUser:user];
                                            [currentUser setFbLogin:YES];
                                            
                                            NSLog(@"User with facebook logged in!");
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        }
                                        
                                    }];
    
    _loginLoadingView.hidden = NO;
    [_activity startAnimating];
}

@end
