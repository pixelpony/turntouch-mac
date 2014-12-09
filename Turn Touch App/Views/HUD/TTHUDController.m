//
//  TTHUDController.m
//  Turn Touch App
//
//  Created by Samuel Clay on 12/4/14.
//  Copyright (c) 2014 Turn Touch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TTHUDController.h"
#import "NSObject+CancelableBlocks.h"

@interface TTHUDController ()

@end

@implementation TTHUDController

@synthesize hudWindow;
@synthesize hudViewController;

- (instancetype)initWithWindowNibName:(NSString *)windowNibName {
    if (self = [super initWithWindowNibName:windowNibName]) {
        [hudWindow setFrame:[self hiddenFrame] display:YES];
    }
    return self;
}

- (void)awakeFromNib {
    appDelegate = (TTAppDelegate *)[NSApp delegate];
    [hudWindow setFrame:[self hiddenFrame] display:YES];
}

#pragma mark - Window management

- (NSRect)visibleFrame {
    NSScreen *mainScreen = [[NSScreen screens] objectAtIndex:0];
    
    return NSMakeRect(0, 0, CGRectGetWidth(mainScreen.frame), 200);
}

- (NSRect)hiddenFrame {
    NSScreen *mainScreen = [[NSScreen screens] objectAtIndex:0];
    
    return NSMakeRect(0, -200, CGRectGetWidth(mainScreen.frame), 200);
}

- (IBAction)fadeIn:(id)sender
{
    [hudWindow makeKeyAndOrderFront:nil];
    [self showWindow:appDelegate];
    
    if (hudWindow.frame.origin.y == [self hiddenFrame].origin.y) {
        [hudWindow setFrame:[self visibleFrame] display:YES];
        [[hudWindow animator] setAlphaValue:0.f];
    }

    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:.2f];
    [[NSAnimationContext currentContext]
     setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];

    [[hudWindow animator] setAlphaValue:1.f];
    [[hudWindow animator] setFrame:[self visibleFrame] display:YES];

    [NSAnimationContext endGrouping];
}

- (IBAction)fadeOut:(id)sender
{
    __block __unsafe_unretained NSWindow *window = hudWindow;

    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:.55f];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
//        [window orderOut:nil];
    }];
    [[NSAnimationContext currentContext]
     setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    [[hudWindow animator] setAlphaValue:0.15f];
    [[hudWindow animator] setFrame:[self hiddenFrame] display:YES];

    [NSAnimationContext endGrouping];
}

#pragma mark - Toasts

- (void)toastActiveMode {
    [self fadeIn:nil];
    
    [self performBlock:^{
        [self fadeOut:nil];
    } afterDelay:0.5 cancelPreviousRequest:YES];
}

@end
