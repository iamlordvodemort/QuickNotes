//
//  SNViewController.h
//  quicknote
//
//  Created by Anthony Layne on 2/15/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btnFBLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;


@property (strong, nonatomic) IBOutlet UIView *loginLoadingView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;

- (IBAction)loginInWithFacebook:(id)sender;

@end
