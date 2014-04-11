//
//  TTModeTitleView.h
//  Turn Touch App
//
//  Created by Samuel Clay on 4/10/14.
//  Copyright (c) 2014 Turn Touch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TTAppDelegate.h"

@class TTAppDelegate;

@interface TTModeTitleView : NSView {
    TTAppDelegate *appDelegate;
    NSImage *modeImage;
    NSString *modeTitle;
    NSDictionary *modeAttributes;
    CGSize textSize;
    NSButton *changeButton;
    BOOL isModeChangeActive;
}

@property (nonatomic) IBOutlet NSButton *changeButton;

@end
