//
//  TTModalPairingInfo.m
//  Turn Touch Remote
//
//  Created by Samuel Clay on 3/10/16.
//  Copyright © 2016 Turn Touch. All rights reserved.
//

#import "TTModalPairingInfo.h"

@implementation TTModalPairingInfo

@synthesize titleLabel;
@synthesize subtitleLabel;
@synthesize heroImage;

- (instancetype)initWithPairing:(TTModalPairing)modalPairing {
    if (self = [super init]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        heroImage = [[NSImageView alloc] init];
        if (modalPairing == MODAL_PAIRING_INTRO) {
            heroImage.image = [NSImage imageNamed:@"modal_remote_hero"];
        } else if (modalPairing == MODAL_PAIRING_SUCCESS) {
            heroImage.image = [NSImage imageNamed:@"modal_remote_paired"];
        } else if (modalPairing == MODAL_PAIRING_FAILURE) {
            heroImage.image = [NSImage imageNamed:@"modal_remote_failed"];
        }
        [self addSubview:heroImage];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:heroImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:heroImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:48.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:heroImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0f constant:260.f]];
        
        titleLabel = [[NSTextField alloc] init];
        if (modalPairing == MODAL_PAIRING_INTRO) {
            titleLabel.stringValue = @"Welcome to Turn Touch";
        } else if (modalPairing == MODAL_PAIRING_SUCCESS) {
            titleLabel.stringValue = @"Working perfectly";
        } else if (modalPairing == MODAL_PAIRING_FAILURE) {
            titleLabel.stringValue = @"Uh Oh";
        }
        titleLabel.editable = NO;
        titleLabel.bordered = NO;
        titleLabel.backgroundColor = [NSColor clearColor];
        titleLabel.font = [NSFont fontWithName:@"Effra" size:16.f];
        titleLabel.textColor = NSColorFromRGB(0x8C979C);
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:heroImage attribute:NSLayoutAttributeBottom multiplier:1.0f constant:36.0f]];
        
        subtitleLabel = [[NSTextField alloc] init];
        if (modalPairing == MODAL_PAIRING_INTRO) {
            subtitleLabel.stringValue = @"Four buttons of beautiful control";
        } else if (modalPairing == MODAL_PAIRING_SUCCESS) {
            subtitleLabel.stringValue = @"Your remote has been paired";
        } else if (modalPairing == MODAL_PAIRING_FAILURE) {
            subtitleLabel.stringValue = @"No remotes could be found";
        }
        subtitleLabel.editable = NO;
        subtitleLabel.bordered = NO;
        subtitleLabel.backgroundColor = [NSColor clearColor];
        subtitleLabel.font = [NSFont fontWithName:@"Effra" size:13.f];
        subtitleLabel.textColor = NSColorFromRGB(0x9A9A9C);
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [subtitleLabel sizeToFit];
        [self addSubview:subtitleLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subtitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subtitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0f constant:18.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subtitleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:36.0f]];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    [NSColorFromRGB(0xEFF1F3) setFill];
    NSRectFill(self.bounds);
}

@end
