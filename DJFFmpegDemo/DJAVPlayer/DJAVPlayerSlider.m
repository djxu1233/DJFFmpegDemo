//
//  DJAVPlayerSlider.m
//  DJFFmpegDemo
//
//  Created by minstone.DJ on 2020/3/25.
//  Copyright © 2020 minstone. All rights reserved.
//

#import "DJAVPlayerSlider.h"
#import "DJAVPlayerHeader.h"

@implementation DJAVPlayerSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.baseView = [[UIView alloc] init];
    self.baseView.backgroundColor = [UIColor grayColor];
    
    self.bufferView = [[UIView alloc] init];
    self.bufferView.backgroundColor = [UIColor lightGrayColor];
    
    self.finishView = [[UIView alloc] init];
    self.finishView.backgroundColor = [UIColor orangeColor];
    
    self.slipImgView = [[UIImageView alloc] init];
    self.slipImgView.image = ImageWithName(@"btn_player_slider_thumb");
    self.slipImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.slipImgView.userInteractionEnabled = YES;
    
    [self addSubview:self.baseView];
    [self addSubview:self.bufferView];
    [self addSubview:self.finishView];
    [self addSubview:self.slipImgView];
    
    
    //masonry
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(SliderH);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.bufferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(SliderH);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.finishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(SliderH);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.slipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.height.mas_equalTo(SlipW);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
   [self addGestureRecognizer:tapGR];
}

#pragma mark - Setter
- (void)setFinishValue:(float)finishValue {
    //解决finishValue报NaN的错误
    if (isnan(finishValue)) {
        finishValue = 0;
    }
    _finishValue = finishValue;
    CGFloat finishW = self.frame.size.width * finishValue;
    [self.finishView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(finishW);
    }];
    [self.slipImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).mas_offset(finishW - SlipW * 0.5);
    }];
}

#pragma mark - Events
- (void)tapGRAction:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    if (self.tapChangeValueBlock) {
        self.tapChangeValueBlock(touchPoint.x / self.frame.size.width);
        self.finishValue = touchPoint.x / self.frame.size.width;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:self] anyObject];
    CGPoint locationPoint = [touch locationInView:self];
    NSLog(@"-------- %@", NSStringFromCGPoint(locationPoint));
    if (locationPoint.x == 0) {
        return;
    }
    self.finishValue = locationPoint.x / self.frame.size.width;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:self] anyObject];
    CGPoint locationPoint = [touch locationInView:self];
    if (locationPoint.x == 0) {
        return;
    }
    self.finishValue = locationPoint.x / self.frame.size.width;
    if (self.tapChangeValueBlock) {
        self.tapChangeValueBlock(locationPoint.x / self.frame.size.width);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}


- (void)layoutSubviews {
    [super layoutSubviews];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
