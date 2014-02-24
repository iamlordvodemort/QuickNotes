//
//  SNRecordViewController.m
//  quicknote
//
//  Created by Anthony Layne on 2/11/14.
//  Copyright (c) 2014 Anthony Layne. All rights reserved.
//

#import "SNRecordViewController.h"
#import "SNNoteViewController.h"
#import "SNUser.h"
#import <AVFoundation/AVAudioSession.h>
#import <AddressBook/AddressBook.h>

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface SNRecordViewController ()
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) SKRecognition *results;
@property (nonatomic) BOOL switchState;
@end

const unsigned char SpeechKitApplicationKey[] = {0xe1, 0xee, 0x48, 0x67, 0x62, 0x8b, 0x58, 0x93, 0x84, 0xee, 0xa7, 0xad, 0x3d, 0x82, 0xa6, 0x46, 0xda, 0x41, 0x66, 0x2f, 0x1e, 0x13, 0xc4, 0xab, 0x1c, 0xd0, 0xbb, 0x88, 0x6c, 0x15, 0xac, 0x4d, 0x03, 0xf5, 0xb4, 0x66, 0x80, 0x0c, 0xf9, 0x04, 0xfb, 0xa1, 0xb1, 0x38, 0x23, 0x58, 0x7e, 0xfe, 0x99, 0xe5, 0x2d, 0xb8, 0xf8, 0xf1, 0x63, 0x15, 0xc1, 0x1e, 0x9d, 0x2d, 0x33, 0x49, 0x7a, 0x37};

@implementation SNRecordViewController

@synthesize session,voiceSearch, switchState;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _vUMeterView.layer.cornerRadius = 100;
    _btnNext.layer.cornerRadius = 5;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    recordEncoding = ENC_AAC;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) {
        // show the signup or login screen
        UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
        [self presentViewController:nav animated:YES completion:nil];
    }else{

        SNUser *currentUser;
        
        if (![[SNUser sharedInstance]user]) {
            currentUser = [[SNUser sharedInstance]initWithUser:[PFUser currentUser]];
            [currentUser setFbLogin:NO];
        }
        
        // Find all notes by the current user
        PFQuery *query = [PFQuery queryWithClassName:@"Note"];
        [query whereKey:@"user" equalTo:currentUser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (objects.count > 0) {
                [[SNUser sharedInstance]setNotesArray:objects];
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }];
    }
    
    if ([PFUser currentUser].isNew) {
        //show tutorial
    }
}

- (NSArray*)getUserFriends:(PFUser *)user {

    NSArray *array = @[];
    
    // Request to authorise the app to use addressbook
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(nil, nil);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // If the app is authorized to access the first time then add the contact
                //[self _addContactToAddressBook];
            } else {
                // Show an alert here if user denies access telling that the contact cannot be added because you didn't allow it to access the contacts
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // If the user user has earlier provided the access, then add the contact
        //[self _addContactToAddressBook];
    }
    else {
        // If the user user has NOT earlier provided the access, create an alert to tell the user to go to Settings app and allow access
    }
    
    return array;
}

- (void) setUpSpeechKit
{
    [SpeechKit setupWithID:@"NMDPTRIAL_vanheuson20140212051442"
                      host:@"sandbox.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:nil];
    
	// Set earcons to play
	SKEarcon* earconStart	= [SKEarcon earconWithName:@"earcon_listening.wav"];
	SKEarcon* earconStop	= [SKEarcon earconWithName:@"earcon_done_listening.wav"];
	SKEarcon* earconCancel	= [SKEarcon earconWithName:@"earcon_cancel.wav"];
	
	[SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
	[SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
	[SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewNotesAction:(id)sender
{
    
    
}

- (IBAction)recordAction:(id)sender
{
    if (!switchState) {
        
        session = [AVAudioSession sharedInstance];
        if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
            [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    // Microphone enabled code
                    NSLog(@"Microphone is enabled..");
                }
                else {
                    // Microphone disabled code
                    NSLog(@"Microphone is disabled..");
                    
                    // We're in a background thread here, so jump to main thread to do UI work.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Microphone Access Denied", nil)
                                                    message:NSLocalizedString(@"This app requires access to your device's Microphone.\n\nPlease enable Microphone access for this app in Settings / Privacy / Microphone", nil)
                                                   delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil] show];
                    });
                }
            }];
        }
         
    }
    else {
        
        if (transactionState == TS_RECORDING) {
            [voiceSearch stopRecording];
        }
        
        else if (transactionState == TS_IDLE) {
            SKEndOfSpeechDetection detectionType = SKLongEndOfSpeechDetection;
            NSString* recoType = SKDictationRecognizerType;
            NSString* langType = @"en_US";
            
            transactionState = TS_INITIAL;
            
            // Nuance can also create a custom recognition type optimized for your application if neither search nor dictation are appropriate. //
            
            NSLog(@"Recognizing type:'%@' Language Code: '%@' using end-of-speech detection:%lu.", recoType, langType, (unsigned long)detectionType);
            
            //if (voiceSearch) [voiceSearch release];
            
            voiceSearch = [[SKRecognizer alloc] initWithType:recoType
                                                   detection:detectionType
                                                    language:langType
                                                    delegate:self];
        }
    }
}

- (IBAction)signOutAction:(id)sender
{
    [PFUser logOut];
    //[self performSegueWithIdentifier:@"showlogin" sender:self];
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)nextAction:(id)sender
{
    
    //NSArray *contacts = [self getUserFriends:[PFUser currentUser]];
}

- (IBAction)switchDictationAction:(id)sender
{
    voiceSearch = nil;
    switchState = _dictationSwitch.on;
    [_dictationSwitch setOn:switchState animated:YES];
    
    if (switchState) {
        [self setUpSpeechKit];
    }
    _btnNext.hidden = switchState;

}

- (IBAction)didLongPressMic:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        // Long press detected, start the timer
        session = [AVAudioSession sharedInstance];
        if ([session respondsToSelector:@selector(requestRecordPermission:)])
        {
            [session performSelector:@selector(requestRecordPermission:)
                          withObject:^(BOOL granted)
            {
                if (granted)
                {
                    // Microphone enabled code
                    NSLog(@"Microphone is enabled..");
                    [self startRecording];
                }
                else {
                    // Microphone disabled code
                    NSLog(@"Microphone is disabled..");
                    
                    // We're in a background thread here, so jump to main thread to do UI work.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Microphone Access Denied", nil)
                                                    message:NSLocalizedString(@"This app requires access to your device's Microphone.\n\nPlease enable Microphone access for this app in Settings / Privacy / Microphone", nil)
                                                   delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil] show];
                    });
                }
            }];
        }
    }
    else
    {
        if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateFailed || recognizer.state == UIGestureRecognizerStateEnded)
        {
            // Long press ended, stop the timer
            [self stopRecording];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    SNNoteViewController *note = [segue destinationViewController];
    note.results = self.results;
    note.fromRecoding = YES;
}

- (void)startPulsing
{
    // ADD ANIMATION
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [anim setFromValue:[NSNumber numberWithFloat:0.5]];
    [anim setToValue:[NSNumber numberWithFloat:1.0]];
    [anim setAutoreverses:YES];
    [anim setDuration:0.5];
    [[[self vUMeterView] layer] addAnimation:anim forKey:@"flash"];
}

- (void)stopPulsing
{
    // REMOVE ANIMATION
    [[[self vUMeterView] layer] removeAnimationForKey:@"flash"];
}

#pragma mark - 
#pragma mark Recording methods

-(void)startRecording
{
    NSLog(@"startRecording");
    audioRecorder = nil;
    
    // Init audio with record capability
    session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryRecord error:nil];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    if(recordEncoding == ENC_PCM)
    {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    else
    {
        NSNumber *formatObject;
        
        switch (recordEncoding) {
            case (ENC_AAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
            case (ENC_IMA4):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                break;
            case (ENC_ULAW):
                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
        
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    }
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", [[NSBundle mainBundle] resourcePath]]];
    
    
    NSError *error = nil;
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    
    if ([audioRecorder prepareToRecord] == YES){
        [audioRecorder record];
    }else {
        int errorCode = CFSwapInt32HostToBig ([error code]);
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        
    }
    NSLog(@"recording");
}

-(IBAction) stopRecording
{
    NSLog(@"stopRecording");
    [audioRecorder stop];
    NSLog(@"stopped");
}

-(IBAction) playRecording
{
    NSLog(@"playRecording");
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    NSLog(@"playing");
}

-(IBAction) stopPlaying
{
    NSLog(@"stopPlaying");
    [audioPlayer stop];
    NSLog(@"stopped");
}


#pragma mark -
#pragma mark SKRecognizerDelegate methods

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording started.");
    
    transactionState = TS_RECORDING;
    //[recordButton setTitle:@"Recording..." forState:UIControlStateNormal];
    //[self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.05];
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording finished.");
    
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateVUMeter) object:nil];
    //[self setVUMeterWidth:0.];
    transactionState = TS_PROCESSING;
    //[recordButton setTitle:@"Processing..." forState:UIControlStateNormal];
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    NSLog(@"Got results.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    transactionState = TS_IDLE;
    //[recordButton setTitle:@"Record" forState:UIControlStateNormal];
    self.results = results;
    [self performSegueWithIdentifier:@"goNote" sender:self];
    
    
	voiceSearch = nil;
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    NSLog(@"Got error.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    transactionState = TS_IDLE;
    //[recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    if (suggestion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    
	voiceSearch = nil;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    // your actions here
    
}

@end

