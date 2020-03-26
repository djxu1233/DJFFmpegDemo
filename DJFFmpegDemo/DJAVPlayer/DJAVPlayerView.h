//
//  DJAVPlayerView.h
//  DJFFmpegDemo
//
//  Created by minstone.DJ on 2020/3/25.
//  Copyright © 2020 minstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DJAVPlayerControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJAVPlayerView : UIView

@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) DJAVPlayerControlView *controlView;
//默认 NO
@property (nonatomic, assign) BOOL isFullScreen;

- (instancetype)initWithPlayerItem:(AVPlayerItem *)playerItem;
- (void)settingPlayerItemWithUrl:(NSURL *)playerUrl;
- (void)settingPlayerItem:(AVPlayerItem *)playerItem;


@end

NS_ASSUME_NONNULL_END
