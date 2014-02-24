//
//  SNRecordViewController.h
//  quicknote
//
//  Created by Anthony Layne on 2/11/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SNRecordViewController : UIViewController <SpeechKitDelegate, SKRecognizerDelegate>
{
    SKRecognizer* voiceSearch;
    enum {
        TS_IDLE,
        TS_INITIAL,
        TS_RECORDING,
        TS_PROCESSING,
    } transactionState;
    
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    int recordEncoding;
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;
}

@property(readonly) SKRecognizer* voiceSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UISwitch *dictationSwitch;
@property (strong, nonatomic) IBOutlet UIView *vUMeterView;

- (IBAction)viewNotesAction:(id)sender;
- (IBAction)recordAction:(id)sender;
- (IBAction)signOutAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)switchDictationAction:(id)sender;
- (IBAction)didLongPressMic:(UILongPressGestureRecognizer *)recognizer;

@end
