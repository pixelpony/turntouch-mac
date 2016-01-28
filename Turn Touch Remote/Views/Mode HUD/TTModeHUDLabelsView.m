//
//  TTModeHUDLabelsView.m
//  Turn Touch Remote
//
//  Created by Samuel Clay on 1/27/16.
//  Copyright © 2016 Turn Touch. All rights reserved.
//

#import "TTModeHUDLabelsView.h"

@implementation TTModeHUDLabelsView

- (id)initWithHUDView:(TTModeHUDView *)HUDView {
    if (self = [super init]) {
        appDelegate = (TTAppDelegate *)[NSApp delegate];
        modeHudView = HUDView;

        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}

#pragma mark - Drawing

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [self drawModeLabelBackgrounds];
    [self drawModeLabels];
}

- (void)drawModeLabelBackgrounds {
    for (NSNumber *directionNumber in @[[NSNumber numberWithInteger:NORTH],
                                        [NSNumber numberWithInteger:EAST],
                                        [NSNumber numberWithInteger:WEST],
                                        [NSNumber numberWithInteger:SOUTH]]) {
        TTModeDirection direction = (TTModeDirection)[directionNumber integerValue];
        NSBezierPath *ellipse = [NSBezierPath bezierPathWithRoundedRect:[self modeLabelFrame:direction]
                                                                xRadius:modeHudView.hudRadius
                                                                yRadius:modeHudView.hudRadius];
        CGFloat alpha = 0.99f;
        NSColor *labelColor = NSColorFromRGBAlpha(0xF1F1F2, alpha);
        if (modeHudView.titleMode != [appDelegate.modeMap modeInDirection:direction]) {
            alpha = 0.6f;
            labelColor = NSColorFromRGBAlpha(0xF1F1F2, alpha);
        }
        [labelColor setFill];
        [ellipse fill];
    }
}

- (void)drawModeLabels {
    for (TTMode *directionMode in @[appDelegate.modeMap.northMode,
                                    appDelegate.modeMap.eastMode,
                                    appDelegate.modeMap.westMode,
                                    appDelegate.modeMap.southMode]) {
        TTModeDirection direction = [directionMode modeDirection];
        NSDictionary *attributes = modeHudView.modeAttributes;
        CGFloat imageAlpha = 1.0f;
        if (modeHudView.titleMode != [appDelegate.modeMap modeInDirection:direction]) {
            attributes = modeHudView.inactiveModeAttributes;
            imageAlpha = 0.9f;
        }
        NSRect frame = [self modeLabelFrame:direction];
        
        // Used to debug label frame
        //        NSBezierPath *textViewSurround = [NSBezierPath bezierPathWithRect:frame];
        //        [textViewSurround setLineWidth:1];
        //        [[NSColor redColor] set];
        //        [textViewSurround stroke];
        
        TTMode *directionMode = [appDelegate.modeMap modeInDirection:direction];
        NSString *imageFilename = [[directionMode class] imageName];
        NSImage *modeImage = [NSImage imageNamed:imageFilename];
        NSString *directionModeTitle = [[[appDelegate.modeMap modeInDirection:direction] class] title];
        NSSize titleSize = [directionModeTitle sizeWithAttributes:modeHudView.modeAttributes];
        [modeImage setSize:NSMakeSize(titleSize.height, titleSize.height)];
        
        CGFloat offset = (NSHeight(frame)/2) - (modeImage.size.height/2);
        NSPoint imagePoint = NSMakePoint(frame.origin.x + modeHudView.hudImageMargin, frame.origin.y + offset);
        [modeImage drawInRect:NSMakeRect(imagePoint.x, imagePoint.y,
                                         modeImage.size.width, modeImage.size.height)
                     fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:imageAlpha];
        
        //        NSLog(@"Mode HUD: %@ - %@ / %@", directionModeTitle, NSStringFromSize(titleSize), NSStringFromRect(frame));
        NSRect textFrame = frame;
        NSInteger fudgeFactor = 8;
        textFrame.origin.x += modeImage.size.width + modeHudView.hudImageMargin + modeHudView.hudImageTextMargin;
        textFrame.origin.y += NSHeight(frame)/2 - titleSize.height/2 + titleSize.height/fudgeFactor;
        textFrame.size.height = titleSize.height;
        [directionModeTitle drawInRect:textFrame withAttributes:attributes];
    }
}

- (NSRect)modeLabelFrame:(TTModeDirection)direction {
    NSScreen *screen = [[NSScreen screens] objectAtIndex:0];
    NSRect mapFrame = [modeHudView mapFrame:NO];
    NSString *directionModeTitle = [[[appDelegate.modeMap modeInDirection:direction] class] title];
    NSSize titleSize = [directionModeTitle sizeWithAttributes:modeHudView.modeAttributes];
    NSInteger imageSize = titleSize.height;
    CGFloat width = titleSize.width + imageSize + modeHudView.hudImageMargin*2 + modeHudView.hudImageTextMargin;
    CGFloat height = titleSize.height + modeHudView.hudImageMargin;
    CGFloat x = 0;
    CGFloat y = 0;
    switch (direction) {
        case NORTH:
            x = (NSWidth(screen.frame) - width)/2;
            y = mapFrame.origin.y + mapFrame.size.height + 8;
            break;
        case EAST:
            x = mapFrame.origin.x + NSWidth(mapFrame) + 24;
            y = mapFrame.origin.y + NSHeight(mapFrame)/2 - height/2;
            break;
        case WEST:
            x = mapFrame.origin.x - width - 24;
            y = mapFrame.origin.y + NSHeight(mapFrame)/2 - height/2;
            break;
        case SOUTH:
            x = (NSWidth(screen.frame) - width)/2;
            y = mapFrame.origin.y - height - 8;
            break;
            
        default:
            break;
    }
    
    return NSMakeRect(x,
                      y,
                      width,
                      height);
}

@end
