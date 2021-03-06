//
//  TTModeHueSleepOptions.m
//  Turn Touch Remote
//
//  Created by Samuel Clay on 1/13/15.
//  Copyright (c) 2015 Turn Touch. All rights reserved.
//

#import "TTModeHue.h"
#import "TTModeHueSleepOptions.h"
#import <HueSDK_OSX/HueSDK.h>

NSString *const kHueDuration = @"hueDuration";
NSString *const kHueDoubleTapDuration = @"hueDoubleTapDuration";

@interface TTModeHueSleepOptions ()

@end

@implementation TTModeHueSleepOptions

@synthesize durationLabel;
@synthesize durationSlider;
@synthesize doubleTapDurationLabel;
@synthesize doubleTapDurationSlider;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger sceneDuration = [[self.action optionValue:kHueDuration inDirection:appDelegate.modeMap.inspectingModeDirection] integerValue];
    [durationSlider setIntegerValue:sceneDuration];
    [self updateSliderLabel:NO];
    
    NSInteger doubleTapSceneDuration = [[self.action optionValue:kHueDoubleTapDuration inDirection:appDelegate.modeMap.inspectingModeDirection] integerValue];
    [doubleTapDurationSlider setIntegerValue:doubleTapSceneDuration];
    [self updateSliderLabel:YES];
}

#pragma mark - Actions

- (IBAction)didChangeDuration:(id)sender {
    NSInteger duration = durationSlider.integerValue;
    [self.action changeActionOption:kHueDuration to:[NSNumber numberWithInteger:duration]];
//    [appDelegate.modeMap changeActionOption:kHueDuration to:[NSNumber numberWithInteger:duration]];
    [self updateSliderLabel:NO];

    NSInteger doubleTapDuration = doubleTapDurationSlider.integerValue;
    [self.action changeActionOption:kHueDoubleTapDuration to:[NSNumber numberWithInteger:doubleTapDuration]];
//    [appDelegate.modeMap changeActionOption:kHueDoubleTapDuration to:[NSNumber numberWithInteger:doubleTapDuration]];
    [self updateSliderLabel:YES];
}

- (void)updateSliderLabel:(BOOL)doubleTap {
    NSInteger duration = doubleTap ? doubleTapDurationSlider.integerValue : durationSlider.integerValue;
    
    NSString *durationString;
    if (duration == 0)       durationString = @"Immediate";
    else if (duration == 1)  durationString = @"1 second";
    else if (duration < 60)  durationString = [NSString stringWithFormat:@"%@ seconds", @(duration)];
    else if (duration < 60*2) durationString = @"1 minute";
    else                     durationString = [NSString stringWithFormat:@"%@ minutes", @(duration/60)];
    
    [(doubleTap ? doubleTapDurationLabel : durationLabel) setStringValue:durationString];
}

@end
