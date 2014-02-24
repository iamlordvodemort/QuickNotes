//
//  SNNoteViewController.h
//  quicknote
//
//  Created by Anthony Layne on 2/12/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>

@interface SNNoteViewController : UIViewController

@property (nonatomic, strong) SKRecognition *results;

@property (strong, nonatomic) IBOutlet UITextField *dateFld;
@property (strong, nonatomic) IBOutlet UITextView *resultTxtView;
@property (nonatomic) BOOL fromRecoding;

@end
