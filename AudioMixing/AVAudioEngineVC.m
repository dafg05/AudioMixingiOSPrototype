//
//  AudioMixingViewController.m
//  AudioMixing
//
//  Created by Daniel Flores Garcia on 7/6/22.
//

#import "AVAudioEngineVC.h"
#import "AVFAudio/AVFAudio.h"

@interface AVAudioEngineVC ()

@property (strong,nonatomic) AVAudioEngine *audioEngine;
@property (strong,nonatomic) AVAudioMixerNode *mixerNode;
@property (strong,nonatomic) NSMutableArray *fileUrlArray;

@end

@implementation AVAudioEngineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Hard code file URLs
    
    NSString *pathToUrl1 = [[NSBundle mainBundle] pathForResource:@"track1" ofType:@"mp3"];
    NSURL *fileUrl1 = [NSURL fileURLWithPath:pathToUrl1];
    NSString *pathToUrl2 = [[NSBundle mainBundle] pathForResource:@"track2" ofType:@"mp3"];
    NSURL *fileUrl2 = [NSURL fileURLWithPath:pathToUrl2];
    NSString *pathToUrl3 = [[NSBundle mainBundle] pathForResource:@"track3" ofType:@"mp3"];
    NSURL *fileUrl3 = [NSURL fileURLWithPath:pathToUrl3];
    
    self.fileUrlArray = [[NSMutableArray alloc] init];
    [self.fileUrlArray addObject:fileUrl1];
    [self.fileUrlArray addObject:fileUrl2];
    [self.fileUrlArray addObject:fileUrl3];
    
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.mixerNode = [[AVAudioMixerNode alloc] init];

}
- (IBAction)didTapFullMix:(id)sender {
    // code from: https://medium.com/@ian.mundy/audio-mixing-on-ios-4cd51dfaac9a
    [self.audioEngine stop];
    [self.audioEngine attachNode:self.mixerNode];
    [self.audioEngine connect:self.mixerNode to:self.audioEngine.outputNode format:nil];

    NSError * __autoreleasing *startError = NULL;
    BOOL results = [self.audioEngine startAndReturnError:startError];

    if (results){
        for (NSURL *fileUrl in self.fileUrlArray){
            AVAudioPlayerNode *playerNode = [[AVAudioPlayerNode alloc] init];
            [self.audioEngine attachNode:playerNode];
            
            NSError * __autoreleasing *readingError = NULL;
            AVAudioFile *file = [[AVAudioFile alloc] initForReading:fileUrl.absoluteURL error:readingError];
            
            [self.audioEngine connect:playerNode to:self.mixerNode format:file.processingFormat];
            
            [playerNode scheduleFile:file atTime:nil completionHandler:nil];
            [playerNode play];
        }
    }
    
}
- (IBAction)didTapTrack1:(id)sender {
    [self playSingleTrack:self.fileUrlArray[0]];
}

- (IBAction)didTapTrack2:(id)sender {
    [self playSingleTrack:self.fileUrlArray[1]];
}

- (IBAction)didTapTrack3:(id)sender {
    [self playSingleTrack:self.fileUrlArray[2]];
}



-(void)playSingleTrack:(NSURL *) fileUrl{
    [self.audioEngine stop];
    NSError * __autoreleasing *readingError = NULL;
    AVAudioFile *file = [[AVAudioFile alloc] initForReading:fileUrl.absoluteURL error:readingError];
    
    AVAudioPlayerNode *playerNode = [[AVAudioPlayerNode alloc] init];
    [self.audioEngine attachNode:playerNode];
    [self.audioEngine connect:playerNode to:self.audioEngine.outputNode format:file.processingFormat];
    
    NSError * __autoreleasing *startError = NULL;
    BOOL results = [self.audioEngine startAndReturnError:startError];
    [playerNode scheduleFile:file atTime:nil completionHandler:nil];
    if (results){
        [playerNode play];
    }
    else{
        NSLog(@"An error occurred");
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
    
