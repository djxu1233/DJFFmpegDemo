//
//  ViewController.m
//  DJFFmpegDemo
//
//  Created by minstone.DJ on 2020/3/25.
//  Copyright © 2020 minstone. All rights reserved.
//

#import "ViewController.h"
//#import "avformat.h"
#import "ffmpeg.h"
#import "DJAVPlayerView.h"
#import "Masonry.h"
#import "DJAVPlayerHeader.h"

@interface ViewController ()

@property (nonatomic, strong) DJAVPlayerView *playerView;
@property (nonatomic, strong) UIButton *convertBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    av_register_all();
    
//    [self normalRun];
//    [self normalRun2];
    
    [self setupAVPlayer];
}

- (void)setupAVPlayer {

    DJAVPlayerView *playerView = [[DJAVPlayerView alloc] init];
    _playerView = playerView;
//    playerView.frame = CGRectMake(0, 0, DefaultPlayerW, DefaultPlayerH);
    
    [self.view addSubview:_playerView];
    
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_equalTo(DefaultPlayerW);
        make.height.mas_equalTo(DefaultPlayerH);
    }];
    
    NSString *moviPath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
    [playerView settingPlayerItemWithUrl:[NSURL fileURLWithPath:moviPath]];
    
    
    UIButton *convertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    convertBtn.backgroundColor = [UIColor orangeColor];
    [convertBtn setTitle:@"视频转图片" forState:UIControlStateNormal];
    [convertBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [convertBtn addTarget:self action:@selector(convertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:convertBtn];
    
    [convertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(44);
        make.top.equalTo(playerView.mas_bottom).mas_offset(80);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    self.convertBtn = convertBtn;
}

- (void)convertBtnClicked:(UIButton *)sender {
    NSLog(@"converBtnClicked");
    
    sender.enabled = NO;
    [sender setTitle:@"IMAGE" forState:UIControlStateNormal];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
        NSString *imageName = @"image%d.jpg";
        NSString *imagesPath = [NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject], imageName];
        
        int argc = 6;
        char **arguments = calloc(argc, sizeof(char*));
        if (arguments != NULL) {
            arguments[0] = "ffmpeg";
            arguments[1] = "-i";
            arguments[2] = (char *)[moviePath UTF8String];
            arguments[3] = "-r";
            arguments[4] = "20";
            arguments[5] = (char *)[imagesPath UTF8String];
            
            if (!ffmpeg_main(argc, arguments)) {
                NSLog(@"视频转图片成功");
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.enabled = YES;
            [sender setTitle:@"视频转图片" forState:UIControlStateNormal];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *imagesArray = [fileManager contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] error:nil];
            
            NSLog(@"imagesArray === %@", imagesArray);
        });
        
    });
}


- (void)normalRun {
    NSString *fromFile = [[NSBundle mainBundle] pathForResource:@"video.mov" ofType:nil];
    NSString *toFile = @"/Users/minstone/Desktop/Output/video.gif";
    
    int argc = 4;
    char **arguments = calloc(argc, sizeof(char*));
    if (arguments != NULL) {
        arguments[0] = "ffmpeg";
        arguments[1] = "-i";
        arguments[2] = (char*)[fromFile UTF8String];
        arguments[3] = (char*)[toFile UTF8String];
        
        if (!ffmpeg_main(argc, arguments)) {
            NSLog(@"生成gif文件成功");
        }
    }
}

- (void)normalRun2 {
    NSString *fromFile = [[NSBundle mainBundle] pathForResource:@"video.mov" ofType:nil];
    NSString *toFile = @"/Users/minstone/Desktop/Output/video.gif";
    
    NSString *command_str = [NSString stringWithFormat:@"ffmpeg -i %@ %@",fromFile,toFile];

//    NSString *command_str = [NSString stringWithString:@"ffmpeg -i %@ %@", fromFile, toFile];
    //分割字符串
    NSMutableArray *argv_arr = [command_str componentsSeparatedByString:(@" ")].mutableCopy;
    
    //获取参数个数
    int argc = (int)argv_arr.count;
    
    //遍历拼接参数
    char **argv = calloc(argc, sizeof(char*));
    
    for (int i = 0; i < argc; i ++) {
        NSString *codeStr = argv_arr[i];
        argv_arr[i] = codeStr;
        argv[i] = (char *)[codeStr UTF8String];
    }
    
    ffmpeg_main(argc, argv);
}


@end
