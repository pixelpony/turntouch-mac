//
//  TTHUDView.m
//  Turn Touch App
//
//  Created by Samuel Clay on 12/4/14.
//  Copyright (c) 2014 Turn Touch. All rights reserved.
//

#import "TTModeHUDView.h"

@implementation TTModeHUDView

const CGFloat kPaddingPct = .6f;
const NSInteger kImageMargin = 32;
const NSInteger kImageSize = 36;
const NSInteger kImageTextMargin = 24;

@synthesize isTeaser;

- (void)awakeFromNib {
    appDelegate = (TTAppDelegate *)[NSApp delegate];
    diamondLabels = [[TTDiamondLabels alloc] initWithInteractive:NO];
    isTeaser = NO;
    [self addSubview:diamondLabels];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self drawMapBackground];
    [self drawLabelBackgrounds];
    [self drawLabels];
    [self drawMap];
}

- (void)drawMapBackground {
    NSRect mapFrame = [self mapFrame];
    NSBezierPath *ellipse = [NSBezierPath bezierPath];
    [ellipse moveToPoint:NSMakePoint(mapFrame.origin.x,
                                     mapFrame.size.height/2 + mapFrame.origin.y)];
    [ellipse lineToPoint:NSMakePoint(mapFrame.size.width/2 + mapFrame.origin.x,
                                     mapFrame.size.height + mapFrame.origin.y)];
    [ellipse lineToPoint:NSMakePoint(mapFrame.size.width + mapFrame.origin.x,
                                     mapFrame.size.height/2 + mapFrame.origin.y)];
    [ellipse lineToPoint:NSMakePoint(mapFrame.size.width/2 + mapFrame.origin.x, mapFrame.origin.y)];
    [ellipse closePath];
    CGFloat alpha = 0.9f;
    [NSColorFromRGBAlpha(0xC0BCCF, alpha) setStroke];
    [ellipse stroke];
    NSGradient *borderGradient = [[NSGradient alloc]
                                  initWithStartingColor:NSColorFromRGBAlpha(0xffffff, alpha)
                                  endingColor:NSColorFromRGB(0xa7a7a7)];
    [borderGradient drawInBezierPath:ellipse angle:-90];
}

- (void)drawLabelBackgrounds {
    for (NSNumber *directionNumber in @[[NSNumber numberWithInteger:NORTH],
                                        [NSNumber numberWithInteger:EAST],
                                        [NSNumber numberWithInteger:WEST],
                                        [NSNumber numberWithInteger:SOUTH]]) {
        TTModeDirection direction = (TTModeDirection)[directionNumber integerValue];
        NSBezierPath *ellipse = [NSBezierPath bezierPathWithRoundedRect:[self labelFrame:direction]
                                                                xRadius:35.0
                                                                yRadius:35.0];
        CGFloat alpha = 0.9f;
        NSGradient *borderGradient = [[NSGradient alloc]
                                      initWithStartingColor:NSColorFromRGBAlpha(0xffffff, alpha)
                                      endingColor:NSColorFromRGBAlpha(0xa7a7a7, alpha)];
        if (titleMode != [appDelegate.modeMap modeInDirection:direction]) {
            alpha = 0.7f;
            borderGradient = [[NSGradient alloc]
                              initWithStartingColor:NSColorFromRGBAlpha(0x404040, alpha)
                              endingColor:NSColorFromRGBAlpha(0x070707, alpha)];
            [NSColorFromRGBAlpha(0xC0BCCF, alpha) setStroke];
        } else {
            [NSColorFromRGBAlpha(0xC0BCCF, alpha) setStroke];
        }
        [ellipse stroke];
        [borderGradient drawInBezierPath:ellipse angle:-90];
    }
}

- (NSRect)mapFrame {
    NSScreen *screen = [[NSScreen screens] objectAtIndex:0];
    CGFloat widthPadding = (screen.frame.size.width * kPaddingPct) / 2;
    CGFloat width = screen.frame.size.width - widthPadding*2;
    CGFloat height = width / 1.3;
    CGFloat heightPadding = (screen.frame.size.height - height) / 2 + 60;

    return NSMakeRect(widthPadding, heightPadding, width, height);
}

- (NSRect)labelFrame:(TTModeDirection)direction {
    NSScreen *screen = [[NSScreen screens] objectAtIndex:0];
    NSRect mapFrame = [self mapFrame];
    NSString *directionModeTitle = [[[appDelegate.modeMap modeInDirection:direction] class] title];
    NSSize titleSize = [directionModeTitle sizeWithAttributes:modeAttributes];
    CGFloat width = titleSize.width + kImageSize + kImageMargin*2 + kImageTextMargin;
    CGFloat height = titleSize.height + kImageMargin/2;
    CGFloat x = 0;
    CGFloat y = 0;
    switch (direction) {
        case NORTH:
            x = (NSWidth(screen.frame) - width)/2;
            y = mapFrame.origin.y + mapFrame.size.height + 36;
            break;
        case EAST:
            x = mapFrame.origin.x + NSWidth(mapFrame) + 36;
            y = mapFrame.origin.y + NSHeight(mapFrame)/2 - height/2;
            break;
        case WEST:
            x = mapFrame.origin.x - width - 36;
            y = mapFrame.origin.y + NSHeight(mapFrame)/2 - height/2;
            break;
        case SOUTH:
            x = (NSWidth(screen.frame) - width)/2;
            y = mapFrame.origin.y - height - 36;
            break;
            
        default:
            break;
    }
    
    return NSMakeRect(x,
                      y,
                      width,
                      height);
}

- (void)drawLabels {
    for (TTMode *directionMode in @[appDelegate.modeMap.northMode,
                                        appDelegate.modeMap.eastMode,
                                        appDelegate.modeMap.westMode,
                                        appDelegate.modeMap.southMode]) {
        TTModeDirection direction = [directionMode modeDirection];
        NSDictionary *attributes = modeAttributes;
        CGFloat alpha = 1.0f;
        if (titleMode != [appDelegate.modeMap modeInDirection:direction]) {
            attributes = inactiveModeAttributes;
            alpha = 0.6f;
        }
        NSRect frame = [self labelFrame:direction];
        TTMode *directionMode = [appDelegate.modeMap modeInDirection:direction];
        modeImage = [NSImage imageNamed:[[directionMode class] imageName]];
        [modeImage setSize:NSMakeSize(kImageSize, kImageSize)];
        CGFloat offset = (NSHeight(frame)/2) - (modeImage.size.height/2);
        NSPoint imagePoint = NSMakePoint(frame.origin.x + kImageMargin, frame.origin.y + offset);
        [modeImage drawInRect:NSMakeRect(imagePoint.x, imagePoint.y,
                                         modeImage.size.width, modeImage.size.height)
                     fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:alpha];
        
        NSString *directionModeTitle = [[directionMode class] title];
        NSSize titleSize = [directionModeTitle sizeWithAttributes:attributes];
        NSPoint titlePoint = NSMakePoint(imagePoint.x + modeImage.size.width + kImageTextMargin,
                                         frame.origin.y + titleSize.height/2 - kImageMargin/2 - 8);
        [directionModeTitle drawAtPoint:titlePoint withAttributes:attributes];
    }
}

- (void)drawMap {
    [diamondLabels setMode:titleMode];
    [diamondLabels setFrame:[self mapFrame]];
}

- (void)setupTitleAttributes {
    [self setupTitleAttributes:appDelegate.modeMap.selectedMode];
}

- (void)setupTitleAttributes:(TTMode *)mode {
    titleMode = mode;
    modeTitle = [[titleMode class] title];
    NSShadow *stringShadow = [[NSShadow alloc] init];
    stringShadow.shadowColor = [NSColor whiteColor];
    stringShadow.shadowOffset = NSMakeSize(0, -1);
    stringShadow.shadowBlurRadius = 0;
    NSShadow *inactiveStringShadow = [[NSShadow alloc] init];
    inactiveStringShadow.shadowColor = [NSColor blackColor];
    inactiveStringShadow.shadowOffset = NSMakeSize(0, -1);
    inactiveStringShadow.shadowBlurRadius = 0;
    NSColor *textColor = NSColorFromRGB(0x404A60);
    CGFloat alpha = 0.5f;
    NSColor *inactiveTextColor = NSColorFromRGBAlpha(0xf9f9f9, alpha);
    modeAttributes = @{NSFontAttributeName:[NSFont fontWithName:@"Effra" size:52],
                       NSForegroundColorAttributeName: textColor,
                       NSShadowAttributeName: stringShadow
                       };
    inactiveModeAttributes = @{NSFontAttributeName:[NSFont fontWithName:@"Effra" size:52],
                               NSForegroundColorAttributeName: inactiveTextColor,
                               NSShadowAttributeName: inactiveStringShadow
                               };
    textSize = [modeTitle sizeWithAttributes:modeAttributes];
}

@end
