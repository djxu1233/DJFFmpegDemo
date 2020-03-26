//
//  DJAVPlayerView.m
//  DJFFmpegDemo
//
//  Created by minstone.DJ on 2020/3/25.
//  Copyright © 2020 minstone. All rights reserved.
//

#import "DJAVPlayerView.h"
#import "Masonry.h"
#import "DJAVPlayerHeader.h"

@interface DJAVPlayerView ()

@property (nonatomic, strong) id timeObserver;
@property (nonatomic, assign) CGRect shrinkRect;

@end

@implementation DJAVPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (instancetype)init {
    if (self = [super init]) {
        self.playerLayer = (AVPlayerLayer *)self.layer;
        self.playerLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
        self.playerLayer.player = self.avPlayer;
        
        [self configControlUI];
        [self addNotification];
    }
    return self;
}

- (instancetype)initWithPlayerItem:(AVPlayerItem *)playerItem {
    if (self = [super init]) {
        self.playerLayer = (AVPlayerLayer *)self.layer;
        self.playerLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
        self.playerLayer.player = self.avPlayer;
        
        self.playerItem = playerItem;
        
        [self.avPlayer replaceCurrentItemWithPlayerItem:self.playerItem];
        
        [self configControlUI];
        [self addNotification];
    }
    return self;
}

- (void)settingPlayerItemWithUrl:(NSURL *)playerUrl {
    [self settingPlayerItem:[AVPlayerItem playerItemWithURL:playerUrl]];
}

- (void)settingPlayerItem:(AVPlayerItem *)playerItem {
    _playerItem = playerItem;
    
    [self removeObserver];
    [self pause];
    
    //切换视频，设置当前视频
    [self.avPlayer replaceCurrentItemWithPlayerItem:playerItem];
    [self addObserver];
}

- (void)configControlUI {
    
//    self.controlView = [[DJAVPlayerControlView alloc] initWithFrame:self.bounds];
    self.controlView = [[DJAVPlayerControlView alloc] init];
    [self addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.controlView.playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.pauseBtn addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.fullScreenBtn addTarget:self action:@selector(fullScreenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.shrinkScreenBtn addTarget:self action:@selector(shrinkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self) weakSelf = self;
    self.controlView.playerSlider.tapChangeValueBlock = ^(float value) {
        CMTime duration = weakSelf.playerItem.duration;
        [weakSelf.playerItem seekToTime:CMTimeMake(CMTimeGetSeconds(duration) * value, 1.0) completionHandler:^(BOOL finished) {
            
        }];
    };
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.controlView.frame = self.bounds;
}


- (void)addNotification {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationHandler) name:UIDeviceOrientationDidChangeNotification object:nil];
    //监听进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    //监听失去焦点，进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignAction) name:UIApplicationWillResignActiveNotification object:nil];
    
}

#pragma mark - Events
- (void)play {
    [self.avPlayer play];
    
    self.controlView.playBtn.hidden = YES;
    self.controlView.pauseBtn.hidden = NO;
}

- (void)pause {
    [self.avPlayer pause];
    
    self.controlView.playBtn.hidden = NO;
    self.controlView.pauseBtn.hidden = YES;
}

- (void)fullScreenBtnClicked {
    [self forceChangeOrientation:UIInterfaceOrientationLandscapeRight];
    self.controlView.fullScreenBtn.hidden = YES;
    self.controlView.shrinkScreenBtn.hidden = NO;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height);
    }];
    
//    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

}

- (void)shrinkBtnClicked {
    [self forceChangeOrientation:UIInterfaceOrientationPortrait];
    self.controlView.fullScreenBtn.hidden = NO;
    self.controlView.shrinkScreenBtn.hidden = YES;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(DefaultPlayerW);
        make.height.mas_equalTo(DefaultPlayerH);
    }];
    
//    self.frame = _shrinkRect;

}

/**
 *    强制横屏
 *
 *    @param orientation 横屏方向
 */
- (void)forceChangeOrientation:(UIInterfaceOrientation)orientation {
    int val = orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

// 更新进度条时间
- (void)updateVideoSlider:(float)currentPlayTime {
//    CMTime duration = _playerItem.duration;
    CMTime duration = self.avPlayer.currentItem.duration;
    
    self.controlView.timeLab.text = [NSString stringWithFormat:@"%.0f: %.0f", currentPlayTime, CMTimeGetSeconds(duration)];
    self.controlView.playerSlider.finishValue = currentPlayTime / CMTimeGetSeconds(duration);
}

// 更新缓冲进度
- (void)updateVideoBufferProgress:(NSTimeInterval)buffer {
    CMTime duration = self.playerItem.duration;
    self.controlView.playerSlider.bufferValue = buffer / CMTimeGetSeconds(duration);
}

- (void)addObserver {
    //监听播放的状态
    [self.avPlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    //监听缓冲加载
    [self.avPlayer.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    //监听播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];
    
    //监控时间进度(根据API提示，如果要监控时间进度，这个对象引用计数器要+1，retain)
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //获取当前 item 播放秒
        float currentPlayTime = (double)weakSelf.avPlayer.currentItem.currentTime.value / weakSelf.avPlayer.currentItem.currentTime.timescale;
        //更新时间进度
        [weakSelf updateVideoSlider:currentPlayTime];
    }];
}

- (void)removeObserver {
    //移除播放状态的监听
    [self.avPlayer.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    //移除缓冲加载的监听
    [self.avPlayer.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    //移除播放完成的监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.avPlayer removeTimeObserver:self.timeObserver];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerItem *avPlayerItem = object;
    
    if ([keyPath isEqualToString:@"status"]) {
        //播放状态
        AVPlayerItemStatus status = [[change objectForKey:@"status"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay: {
                [self play];
            }
                break;
            case AVPlayerItemStatusFailed:
                NSLog(@"加载失败");
                break;
                
            case AVPlayerItemStatusUnknown:
                NSLog(@"未知资源");
                break;
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = avPlayerItem.loadedTimeRanges;
        //缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durantionSeconds = CMTimeGetSeconds(timeRange.duration);
        //缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durantionSeconds;
        [self updateVideoBufferProgress:totalBuffer];
    } else if ([keyPath isEqualToString:@"rate"]) {
        // rate=1:播放，rate!=1:非播放
        
    } else if ([keyPath isEqualToString:@"currentItem"]) {
       
    }
}

#pragma mark - Notification Handler
//设备屏幕旋转通知
- (void)orientationHandler {
    
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ||
        [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            _isFullScreen = YES;
        } else _isFullScreen = NO;
    } else {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            _isFullScreen = YES;
        } else _isFullScreen = NO;
    }
}

//应用将要进入前台
- (void)applicationDidEnterForeground {
    [self play];
}

//应用将要失去焦点
- (void)applicationWillResignAction {
    [self pause];
}

//播放结束通知
- (void)playFinished:(NSNotification *)notif {
    
    [self.avPlayer seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        
    }];
    [self pause];
}


- (void)setIsFullScreen:(BOOL)isFullScreen {
    _isFullScreen = isFullScreen;
    if (_isFullScreen) {
        [self fullScreenBtnClicked];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (!_isFullScreen) {
        _shrinkRect = frame;
    }
}

- (AVPlayer *)avPlayer {
    if (!_avPlayer) {
        _avPlayer = [[AVPlayer alloc] init];
        //获取系统声音音量
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        CGFloat currentVolume = session.outputVolume;
        _avPlayer.volume = currentVolume;
    }
    return _avPlayer;
}

- (void)dealloc {
    [self removeObserver];
    //注销通知
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    self.avPlayer = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
