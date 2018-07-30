//
//  SliderViewController.m
//  MToolsDemo
//
//  Created by 马慧莹 on 2018/7/30.
//  Copyright © 2018年 magic. All rights reserved.
//

#import "SliderViewController.h"
#import "MSliderProgressView.h"
@interface SliderViewController ()<MSliderViewDelegate>
@property (nonatomic, strong) MSliderProgressView *slider;

@property (nonatomic, strong) NSTimer *sliderTimer;

@property (nonatomic, strong) NSTimer *bufferTimer;
@end

@implementation SliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.slider];
    
    [self sliderTimer];
    [self bufferTimer];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.sliderTimer invalidate];
    self.sliderTimer = nil;
    [self.bufferTimer invalidate];
    self.bufferTimer = nil;
}

- (void)sliderEvent{
    float value = self.slider.sliderValue;
    self.slider.sliderValue = value + 0.004;
}

- (void)bufferEvent{
    self.slider.bufferValue = self.slider.bufferValue + 0.01;
}

- (MSliderProgressView *)slider {
    if (!_slider) {
        _slider = [[MSliderProgressView alloc] initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width-20, 30)];
        _slider.delegate = self;
        _slider.maxTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:[UIImage imageNamed:@"Player_slider"] forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

-(NSTimer *)sliderTimer{
    if (!_sliderTimer) {
        _sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sliderEvent) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_sliderTimer forMode:NSDefaultRunLoopMode];
    }
    return _sliderTimer;
}

-(NSTimer *)bufferTimer{
    if (!_bufferTimer) {
        _bufferTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(bufferEvent) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_bufferTimer forMode:NSDefaultRunLoopMode];
    }
    return _bufferTimer;
}

- (void)dealloc{
    NSLog(@"aaaa");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
