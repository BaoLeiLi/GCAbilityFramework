//
//  GCRecordVoice.m
//  GCMobileAbility
//
//  Created by 李保磊 on 2017/12/11.
//  Copyright © 2017年 USTC Sinovate Software Co.,Ltd. All rights reserved.
//

#import "GCRecordVoice.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"

NSString *const kRecordVoiceTime = @"RecordVoiceTimeLength";
NSString *const kRecordVoiceFileName = @"RecordVoiceFileName";
NSString *const kRecordVoiceFilePath = @"RecordVoiceFilePath";
NSString *const kRecordVoiceFileSize = @"kRecordVoiceFileSize";

@interface GCRecordVoice ()
{
    NSString *mp3FilePath;
}

@property (nonatomic,copy) NSString  *filePath;
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址


@end

@implementation GCRecordVoice


+ (instancetype)shareRecordVoice{
    
    static GCRecordVoice *voice = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        voice = [[GCRecordVoice alloc] init];
    });
    return voice;
}

- (void)startRecord:(NSString *)keyword{
    
    NSLog(@"开始录音");
    
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if (session == nil) {
        
        NSLog(@"Error creating session: %@",[sessionError description]);
        
    }else{
        
        [session setActive:YES error:nil];
        
    }
    
    self.session = session;
    
    //1.获取沙盒地址
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *voiceFolder = [path stringByAppendingPathComponent:@"RecordVoice"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:voiceFolder]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:voiceFolder withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            
            NSLog(@"error : %@",error);
            
            return;
        }
    }
    _fileName = [self getFileName:keyword];
    NSString *fileFullName = [NSString stringWithFormat:@"%@.wav",_fileName];
    _filePath = [voiceFolder stringByAppendingPathComponent:fileFullName];
    
    
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:_filePath];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
    
    if (_recorder) {
        
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        
    }else{
        
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
    }
    
}

- (NSDictionary *)stopRecord{
    
    NSLog(@"停止录音");
    
    if ([self.recorder isRecording]) {
        
        [self.recorder stop];
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.filePath]){
        
        NSString *timeStr = [NSString stringWithFormat:@"%.02f",[[manager attributesOfItemAtPath:_filePath error:nil] fileSize]/1024.0];
        
        NSDictionary *voiceInfo = @{kRecordVoiceTime:timeStr,kRecordVoiceFileName:_fileName,kRecordVoiceFilePath:_filePath};
        
        return voiceInfo;
        
    }else{
        
        return nil;
        
    }
}

#pragma mark - wav转MP3 -
- (void)audio_PCMtoMP3
{
    
//    [MBProgressHUD showMessage:@"正在转换MP3"];
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *voiceFolder = [documentDir stringByAppendingPathComponent:@"RecordVoice"];
    
    mp3FilePath = [voiceFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_mp3.mp3",_fileName]];
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil])
    {
        NSLog(@"删除");
    }
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([_filePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 22050.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
//        NSError *playerError;
//        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:mp3FilePath]error:&playerError];
//        audioPalyer = audioPlayer;
//        audioPalyer.volume = 1.0f;
//        if (audioPalyer == nil)
//        {
//            NSLog(@"ERror creating player: %@", [playerError description]);
//        }
//        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
//        audioPalyer.delegate = self;
        
    }
    
    if (mp3FilePath != nil) {
//        [self playing];
    }
}

/**
 *  @brief 获取文件名
 */
- (NSString *)getFileName:(NSString *)keyword{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@_%@",keyword,dateStr];
}

@end
