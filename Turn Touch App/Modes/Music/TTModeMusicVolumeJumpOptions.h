//
//  TTModeMusicVolumeJumpOptions.h
//  Turn Touch App
//
//  Created by Samuel Clay on 2/19/15.
//  Copyright (c) 2015 Turn Touch. All rights reserved.
//

#import "TTOptionsDetailViewController.h"

@interface TTModeMusicVolumeJumpOptions : TTOptionsDetailViewController

@property (nonatomic) IBOutlet NSTextField *percentageLabel;
@property (nonatomic) IBOutlet NSSlider *volumeSlider;

- (IBAction)slideVolume:(id)sender;

@end