//
//  DJAVPlayerControlView.h
//  DJFFmpegDemo
//
//  Created by minstone.DJ on 2020/3/25.
//  Copyright © 2020 minstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJAVPlayerSlider.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJAVPlayerControlView : UIView

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, strong) UIButton *shrinkScreenBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) DJAVPlayerSlider *playerSlider;

//是否锁屏
@property (nonatomic, assign) BOOL isLock;
//菜单是否显示
@property (nonatomic, assign) BOOL menuShow;

@end

NS_ASSUME_NONNULL_END
