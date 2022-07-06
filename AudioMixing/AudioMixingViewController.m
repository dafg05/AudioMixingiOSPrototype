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

@property (strong,nonatomic) AVAudioEngine *audioEngine;
@property (strong,nonatomic) AVAudioMixerNode *mixerNode;
@property (strong,nonatomic) NSMutableArray *filePathArray;

@end

@implementation AudioMixingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Hard code file URLs
    self.filePathArray = [[NSMutableArray alloc] init];
    NSString *pathToUrl1 = [[NSBundle mainBundle] pathForResource:@"track1" ofType:@"mp3"];
    NSString *pathToUrl2 = [[NSBundle mainBundle] pathForResource:@"track2" ofType:@"mp3"];
    NSString *pathToUrl3 = [[NSBundle mainBundle] pathForResource:@"track3" ofType:@"mp3"];
    [self.filePathArray addObject:pathToUrl1];
    [self.filePathArray addObject:pathToUrl2];
    [self.filePathArray addObject:pathToUrl3];
}
- (IBAction)didTapAVAudioEngine:(id)sender {
    // code from: https://medium.com/@ian.mundy/audio-mixing-on-ios-4cd51dfaac9a
    NSLog(@"file count: %lu", self.filePathArray.count);
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.mixerNode = [[AVAudioMixerNode alloc] init];
    
    NSLog(@"On AVAudioEngine"); 
    [self.audioEngine attachNode:self.mixerNode];
    [self.audioEngine connect:self.mixerNode to:self.audioEngine.outputNode format:nil];
    
    NSError * __autoreleasing *startError = NULL;
    BOOL results = [self.audioEngine startAndReturnError:startError];
    if (results){
        for (NSString *filePath in self.filePathArray){
            NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
    
