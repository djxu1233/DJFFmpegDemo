//
//  DJAVPlayerControlView.m
//  DJFFmpegDemo
//
//  Created by minstone.DJ on 2020/3/25.
//  Copyright © 2020 minstone. All rights reserved.
//

#import "DJAVPlayerControlView.h"
#import "DJAVPlayerHeader.h"

@interface DJAVPlayerControlView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timerIndex;
@property (nonatomic, assign) BOOL isAnimate;

@end

@implementation DJAVPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.menuShow = YES;
        self.timerIndex = 0;
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    // alloc init
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = [UIColor whiteColor];
    self.titleLab.font = [UIFont systemFontOfSize:15];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"btn_player_quit"] forState:UIControlStateNormal];
    self.closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"btn_player_pause"] forState:UIControlStateNormal];
    self.playBtn.contentMode = UIViewContentModeScaleAspectFit;
    
    self.pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pauseBtn setImage:[UIImage imageNamed:@"btn_player_play"] forState:UIControlStateNormal];
    self.pauseBtn.contentMode = UIViewContentModeScaleAspectFit;
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.backgroundColor = [UIColor clearColor];
    self.timeLab.textColor = [UIColor lightTextColor];
    self.timeLab.font = [UIFont systemFontOfSize:13];
    self.timeLab.textAlignment = NSTextAlignmentRight;
    self.timeLab.text = @"00:00";
    
    self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
    
    self.shrinkScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shrinkScreenBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
    
    
    self.playerSlider = [[DJAVPlayerSlider alloc] init];
    self.playerSlider.finishValue = 0;
    
    //add subviews
    [self addSubview:self.topView];
    [self.topView addSubview:self.titleLab];
    [self.topView addSubview:self.closeBtn];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.playBtn];
    [self.bottomView addSubview:self.pauseBtn];
    [self.bottomView addSubview:self.timeLab];
    [self.bottomView addSubview:self.fullScreenBtn];
    [self.bottomView addSubview:self.shrinkScreenBtn];
    [self.bottomView addSubview:self.playerSlider];
    
    
    //masonry
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(TopMenuH);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top);
        make.left.equalTo(self.topView.mas_left).mas_offset(10);
        make.width.mas_equalTo(4 * TopMenuH);
        make.height.mas_equalTo(TopMenuH);
    }];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top);
        make.left.equalTo(self.closeBtn.mas_right).mas_offset(- 3 * TopMenuH);
        make.right.equalTo(self.topView.mas_right).mas_offset(- TopMenuH);
        make.height.mas_equalTo(TopMenuH);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(BotMenuH);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).mas_offset(10);
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.width.height.mas_equalTo(TopMenuH);
    }];
    
    [self.pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).mas_offset(10);
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.width.height.mas_equalTo(TopMenuH);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right).mas_offset(-10);
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.width.height.mas_equalTo(TopMenuH);
    }];
    
    [self.shrinkScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right).mas_offset(-10);
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.width.height.mas_equalTo(TopMenuH);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreenBtn.mas_left);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(TopMenuH);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    
    [self.playerSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right);
        make.right.equalTo(self.timeLab.mas_left).mas_offset(-5);
        make.height.mas_equalTo(BotMenuH);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    
    [self.timer fire];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(controlViewTapGRAction:)];
    [self addGestureRecognizer:tapGR];
    
    self.playBtn.hidden = YES;
    self.shrinkScreenBtn.hidden = YES;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - Events
- (void)timerRunAction {
    self.timerIndex ++;
    if (self.timerIndex == 3) {
        self.timerIndex = 0;
        [self.timer setFireDate:[NSDate distantFuture]];
        [self hideAnimate];
    }
}

- (void)controlViewTapGRAction:(UITapGestureRecognizer *)tapGR {
    //暂停定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    self.timerIndex = 0;
    if (tapGR.numberOfTapsRequired == 1) {
        if (self.menuShow) {
            [self hideAnimate];
        }else
        {
            [self showAnimate];
        }
    }
}

- (void)hideAnimate {
    if (self.isAnimate) {
        return;
    }
    self.timerIndex = 0;
    self.isAnimate = YES;
    [UIView animateWithDuration:0.5 animations:^{
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).mas_offset(- TopMenuH);
        }];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).mas_offset(BotMenuH);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.topView.hidden = YES;
        self.bottomView.hidden = YES;
        self.menuShow = NO;
        self.isAnimate = NO;
        
    }];
}

- (void)showAnimate {
    if (self.isAnimate) {
        return;
    }
    self.topView.hidden = NO;
    self.bottomView.hidden = NO;
    self.isAnimate = YES;
    [UIView animateWithDuration:0.25 animations:^{
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
        }];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.menuShow = YES;
        self.isAnimate = NO;
        //恢复定时器
        [self.timer setFireDate:[NSDate distantPast]];
        
    }];
}

#pragma mark - Lazy Initialized
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRunAction) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
