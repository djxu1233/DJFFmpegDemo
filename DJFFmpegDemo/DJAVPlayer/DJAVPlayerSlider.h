//
//  DJAVPlayerSlider.h
//  DJFFmpegDemo
//
//  Created by minstone.DJ on 2020/3/25.
//  Copyright © 2020 minstone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DJAVPlayerSliderTapChangeValueBlock)(float value);

@interface DJAVPlayerSlider : UIView

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *finishView;
@property (nonatomic, strong) UIView *bufferView;
@property (nonatomic, strong) UIImageView *slipImgView;

@property (nonatomic, assign) float finishValue;
@property (nonatomic, assign) float bufferValue;

@property (nonatomic, copy) DJAVPlayerSliderTapChangeValueBlock tapChangeValueBlock;

@end

NS_ASSUME_NONNULL_END
