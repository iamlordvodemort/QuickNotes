//
//  SNNoteViewController.m
//  quicknote
//
//  Created by Anthony Layne on 2/12/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import "SNNoteViewController.h"

@interface SNNoteViewController ()

@end

@implementation SNNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.fromRecoding) {
        //came from recording
        
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd, yyyy - h:mm a"];
        
        NSString *dateTime = [formatter stringFromDate:now];
        _dateFld.text = NSLocalizedString(dateTime, nil);
        
        long numOfResults = [self.results.results count];
        if (numOfResults > 0){
            _resultTxtView.text = [self.results firstResult];
        }
        
        if (numOfResults > 1){
            
            NSString *alternative = [NSString stringWithFormat:@"%@\n\nAlternative:\n%@",_resultTxtView.text, [[self.results.results subarrayWithRange:NSMakeRange(1, numOfResults-1)] componentsJoinedByString:@"\n"]];

            _resultTxtView.text = NSLocalizedString(alternative, nil);
        }
        
        if (self.results.suggestion) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Suggestion", nil)
                                                            message:NSLocalizedString(self.results.suggestion, nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
    //came from saved notes
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
