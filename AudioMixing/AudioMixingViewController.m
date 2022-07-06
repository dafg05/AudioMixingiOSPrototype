//
//  AudioMixingViewController.m
//  AudioMixing
//
//  Created by Daniel Flores Garcia on 7/6/22.
//

#import "AudioMixingViewController.h"
//#import "AVFAudio/AVAudioEngine.h"
//#import "AVFAudio/AVAudioMixerNode.h"
//#import "AVFAudio/AVAudioPlayerNode.h"
#import "AVFAudio/AVFAudio.h"

@interface AudioMixingViewController ()

@property (weak,nonatomic) AVAudioEngine *audioEngine;
@property (weak,nonatomic) AVAudioMixerNode *mixer;
@property (strong,nonatomic) NSMutableArray *fileUrlArray;

@end

@implementation AudioMixingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Hard code file URLs
    [self.fileUrlArray addObject:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"track1" ofType:@"mp3"]]];
    [self.fileUrlArray addObject:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"track2" ofType:@"mp3"]]];
    [self.fileUrlArray addObject:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"track2" ofType:@"mp3"]]];
    
}
- (IBAction)didTapAVAudioEngine:(id)sender {
    // code from: https://medium.com/@ian.mundy/audio-mixing-on-ios-4cd51dfaac9a
    // originally in swift
    NSLog(@"On AVAudioEngine");
    [self.audioEngine attachNode:self.mixer];
    [self.audioEngine connect:self.mixer to:self.audioEngine.outputNode format:nil];
    
    // Don't know how or what to pass as a parameter to startAndReturnError
    NSError * __autoreleasing *startError = NULL;
    BOOL results = [self.audioEngine startAndReturnError:startError];
    if (results){
        // code block never reached -- results always false, meaning audio engine not starting
        for (NSURL *fileUrl in self.fileUrlArray){
            AVAudioPlayerNode *audioPlayer = [[AVAudioPlayerNode alloc] init];
            [self.audioEngine attachNode:audioPlayer];
            
            // Same issue: don't know how (or what) to pass in as an error parameter to initForReading
            NSError * __autoreleasing *readingError = NULL;
            AVAudioFile *file = [[AVAudioFile alloc] initForReading:fileUrl error:readingError];
            
            [audioPlayer scheduleFile:file atTime:nil completionHandler:nil];
            [audioPlayer play];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
    
