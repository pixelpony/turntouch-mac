//
//  TTDiamondView.m
//  Turn Touch App
//
//  Created by Samuel Clay on 11/1/13.
//  Copyright (c) 2013 Turn Touch. All rights reserved.
//

#import "TTModeMap.h"
#import "TTDiamondView.h"

@implementation TTDiamondView

@synthesize size = _size;
@synthesize isHighlighted = _isHighlighted;
@synthesize overrideSelectedDirection;
@synthesize overrideActiveDirection;
@synthesize ignoreSelectedMode;
@synthesize ignoreActiveMode;
@synthesize showOutline;
@synthesize interactive;
@synthesize statusBar;

#pragma mark - Initialization


- (id)initWithFrame:(NSRect)frame {
    return [self initWithFrame:frame interactive:NO];
}

- (id)initWithFrame:(NSRect)frame interactive:(BOOL)_interactive {
    self = [super initWithFrame:frame];
    if (self) {
        self.size = NSWidth(frame);
        self.isHighlighted = NO;
        self.showOutline = NO;
        self.interactive = _interactive;
        self.overrideSelectedDirection = NO_DIRECTION;
        self.overrideActiveDirection = NO_DIRECTION;
        self.ignoreSelectedMode = NO;
        self.ignoreActiveMode = NO;
        
        appDelegate = [NSApp delegate];
        
        [self registerAsObserver];
        [self createTrackingArea];
    }
    
    return self;
}

- (void)setFrame:(NSRect)frameRect {
    [super setFrame:frameRect];
    self.size = NSWidth(self.frame);
//    NSLog(@"Diamond size: %f", self.size);
}

- (void)registerAsObserver {
    if (interactive) {
        [appDelegate.modeMap addObserver:self forKeyPath:@"inspectingModeDirection"
                                 options:0 context:nil];
        [appDelegate.modeMap addObserver:self forKeyPath:@"hoverModeDirection"
                                 options:0 context:nil];
    }
    [appDelegate.modeMap addObserver:self forKeyPath:@"activeModeDirection"
                             options:0 context:nil];
    [appDelegate.modeMap addObserver:self forKeyPath:@"selectedModeDirection"
                             options:0 context:nil];
    [appDelegate.modeMap addObserver:self forKeyPath:@"selectedMode"
                             options:0 context:nil];
}

- (void) observeValueForKeyPath:(NSString*)keyPath
                       ofObject:(id)object
                         change:(NSDictionary*)change
                        context:(void*)context {
    if ([keyPath isEqual:NSStringFromSelector(@selector(inspectingModeDirection))]) {
        [self setNeedsDisplay:YES];
    } else if ([keyPath isEqual:NSStringFromSelector(@selector(hoverModeDirection))]) {
        [self setNeedsDisplay:YES];
    } else if ([keyPath isEqual:NSStringFromSelector(@selector(activeModeDirection))]) {
        [self setNeedsDisplay:YES];
    } else if ([keyPath isEqual:NSStringFromSelector(@selector(selectedModeDirection))]) {
        [self setNeedsDisplay:YES];
    } else if ([keyPath isEqual:NSStringFromSelector(@selector(selectedMode))]) {
        [self setNeedsDisplay:YES];
    }
}

#pragma mark - Drawing

- (BOOL)wantsDefaultClipping {
    return NO;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    NSRect rect = self.bounds;

    [self drawPaths:rect];
    [self colorPaths:rect];
}

- (void)drawPaths:(NSRect)rect {
//    NSLog(@"Draw diamond: %@ - %@", NSStringFromRect(rect), NSStringFromRect(self.bounds));
    CGFloat width = NSMaxX(rect);
    CGFloat height = NSMaxY(rect);
    CGFloat spacing = SPACING_PCT * width;
    
    northPath = [NSBezierPath bezierPath];
    [northPath moveToPoint:NSMakePoint(width / 2,
                                       height)];
    [northPath lineToPoint:NSMakePoint(width * 1/4 + spacing,
                                       height * 3/4 + spacing)];
    [northPath lineToPoint:NSMakePoint(width / 2,
                                       height/2 + spacing*2)];
    [northPath lineToPoint:NSMakePoint(width * 3/4 - spacing,
                                       height * 3/4 + spacing)];
    [northPath setLineJoinStyle:NSBevelLineJoinStyle];
    [northPath closePath];
    
    eastPath = [NSBezierPath bezierPath];
    [eastPath moveToPoint:NSMakePoint(width * 3/4 + spacing,
                                      height * 3/4 - spacing)];
    [eastPath lineToPoint:NSMakePoint(width * 1/2 + spacing*2,
                                      height * 1/2)];
    [eastPath lineToPoint:NSMakePoint(width * 3/4 + spacing,
                                      height * 1/4 + spacing)];
    [eastPath lineToPoint:NSMakePoint(width,
                                      height * 1/2)];
    [eastPath setLineJoinStyle:NSBevelLineJoinStyle];
    [eastPath closePath];

    westPath = [NSBezierPath bezierPath];
    [westPath moveToPoint:NSMakePoint(width * 1/4 - spacing,
                                      height * 3/4 - spacing)];
    [westPath lineToPoint:NSMakePoint(0,
                                      height * 1/2)];
    [westPath lineToPoint:NSMakePoint(width * 1/4 - spacing,
                                      height * 1/4 + spacing)];
    [westPath lineToPoint:NSMakePoint(width * 1/2 - spacing*2,
                                      height * 1/2)];
    [westPath setLineJoinStyle:NSBevelLineJoinStyle];
    [westPath closePath];
    
    southPath = [NSBezierPath bezierPath];
    [southPath moveToPoint:NSMakePoint(width * 1/2,
                                       height * 1/2 - spacing*2)];
    [southPath lineToPoint:NSMakePoint(width * 1/4 + spacing,
                                       height * 1/4 - spacing)];
    [southPath lineToPoint:NSMakePoint(width * 1/2,
                                       0)];
    [southPath lineToPoint:NSMakePoint(width * 3/4 - spacing,
                                       height * 1/4 - spacing)];
    [southPath setLineJoinStyle:NSBevelLineJoinStyle];
    [southPath closePath];
}

- (void)colorPaths:(NSRect)rect {
    CGFloat width = NSMaxX(rect);
    CGFloat height = NSMaxY(rect);
    CGFloat spacing = SPACING_PCT * width;
    TTModeDirection activeModeDirection = ignoreActiveMode ? overrideActiveDirection : appDelegate.modeMap.activeModeDirection;
    TTModeDirection selectedModeDirection = ignoreSelectedMode ? overrideSelectedDirection : appDelegate.modeMap.selectedModeDirection;
    TTModeDirection inspectingModeDirection = appDelegate.modeMap.inspectingModeDirection;
    TTModeDirection hoverModeDirection = appDelegate.modeMap.hoverModeDirection;

    for (NSBezierPath *path in @[northPath, eastPath, westPath, southPath]) {
        TTModeDirection direction = NO_DIRECTION;
        
        if ([path isEqual:northPath]) {
            direction = NORTH;
        } else if ([path isEqual:eastPath]) {
            direction = EAST;
        } else if ([path isEqual:westPath]) {
            direction = WEST;
        } else if ([path isEqual:southPath]) {
            direction = SOUTH;
        }

        BOOL isHoveringDirection = hoverModeDirection == direction;
        BOOL isInspectingDirection = inspectingModeDirection == direction;
        BOOL isSelectedDirection = selectedModeDirection == direction;
        BOOL isActiveDirection = activeModeDirection == direction;
        
        // Draw the shadow
        if (!showOutline && !self.isHighlighted) {
            [NSGraphicsContext saveGraphicsState];
            NSAffineTransform *transform = [NSAffineTransform transform];
            [transform translateXBy:0 yBy:-0.25f];
            NSBezierPath *shadowPath = [path copy];
            [shadowPath transformUsingAffineTransform:transform];
            [[NSColor colorWithDeviceWhite:1.0f alpha:0.4f] setStroke];
            if (path == northPath) {
                [[NSBezierPath bezierPathWithRect:NSMakeRect(width*1/4+spacing*2, height*3/4,
                                                             width*2/4-spacing*4, -1 * height*1/4)]
                 setClip];
            } else if (path == eastPath) {
                [[NSBezierPath bezierPathWithRect:NSMakeRect(width*1/2+spacing*2, height*1/2,
                                                             width*2/4-spacing*2, -1 * height*1/4)]
                 setClip];
            } else if (path == westPath) {
                [[NSBezierPath bezierPathWithRect:NSMakeRect(0, height*1/2,
                                                             width*2/4-spacing*2, -1 * height*1/4)]
                 setClip];
            } else if (path == southPath) {
                [[NSBezierPath bezierPathWithRect:NSMakeRect(width*1/4+spacing*2, 0,
                                                             width*2/4-spacing*4, height*1/4)]
                 setClip];
            }
            [shadowPath setLineWidth:0.25f];
            [shadowPath stroke];
            [NSGraphicsContext restoreGraphicsState];
        }
        
        // Fill in the color as a stroke or fill
        NSColor *modeColor;
        if (interactive) {
            if (isHoveringDirection && !isInspectingDirection) {
                modeColor = NSColorFromRGB(0x505AC0);
            } else if (isInspectingDirection) {
                modeColor = NSColorFromRGB(0x303AA0);
            } else {
                modeColor = NSColorFromRGB(0xD3D7D9);
            }
        } else if (statusBar) {
            if (isSelectedDirection) {
                modeColor = self.isHighlighted ? NSColorFromRGB(0xFFFFFF) :
                                                 NSColorFromRGB(0x1555D8);
            } else if (self.isHighlighted) {
                CGFloat alpha = isActiveDirection ? 0.8 : isSelectedDirection ? 1.0 : 0.4;
                modeColor = NSColorFromRGBAlpha(0xFFFFFF, alpha);
            } else {
                CGFloat alpha = 0.5f;
                modeColor = NSColorFromRGBAlpha(0x303033, alpha);
            }
        } else {
            if (isSelectedDirection) {
                if (appDelegate.modeMap.selectedModeDirection == direction) {
                    CGFloat alpha = 0.8f;
                    modeColor = NSColorFromRGBAlpha(0x1555D8, alpha);
                } else {
                    CGFloat alpha = 0.7f;
                    modeColor = NSColorFromRGBAlpha(0x303033, alpha);
                }
            } else if (isActiveDirection) {
                CGFloat alpha = 0.5f;
                modeColor = NSColorFromRGBAlpha(0x303033, alpha);
            } else {
                CGFloat alpha = 0.2f;
                modeColor = NSColorFromRGBAlpha(0x606063, alpha);
            }
        }
        
        if (!showOutline) {
            [modeColor setFill];
            [path fill];
        } else {
            path.lineWidth = isInspectingDirection ? 3.0f : 1.0f;
            [modeColor setStroke];
            [path stroke];
        }
    }
}

- (void)setHighlighted:(BOOL)newFlag {
    if (_isHighlighted == newFlag) return;
    _isHighlighted = newFlag;
    [self setNeedsDisplay:YES];
}

#pragma mark - Events

- (void)updateTrackingAreas {
    [self createTrackingArea];
}

- (void)createTrackingArea {
    if (!interactive) return;
    for (NSTrackingArea *area in self.trackingAreas) {
        [self removeTrackingArea:area];
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways |
                NSTrackingMouseMoved | NSTrackingActiveInKeyWindow);
    NSTrackingArea *trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                                 options:opts
                                                                   owner:self
                                                                userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (!interactive) {
        [super mouseUp:theEvent];
        return;
    }
    
    NSPoint location = [theEvent locationInWindow];
    NSPoint center = [self convertPoint:location fromView:nil];
    
    if ([northPath containsPoint:center]) {
        [appDelegate.modeMap toggleInspectingModeDirection:NORTH];
    } else if ([eastPath containsPoint:center]) {
        [appDelegate.modeMap toggleInspectingModeDirection:EAST];
    } else if ([westPath containsPoint:center]) {
        [appDelegate.modeMap toggleInspectingModeDirection:WEST];
    } else if ([southPath containsPoint:center]) {
        [appDelegate.modeMap toggleInspectingModeDirection:SOUTH];
    }
}

- (void)mouseMoved:(NSEvent *)theEvent {
    if (!interactive) {
        [super mouseMoved:theEvent];
        return;
    }
    
    [self mouseMovement:theEvent hovering:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [appDelegate.modeMap toggleHoverModeDirection:NO_DIRECTION hovering:NO];
}

- (void)mouseMovement:(NSEvent *)theEvent hovering:(BOOL)hovering {
    NSPoint location = [theEvent locationInWindow];
    NSPoint center = [self convertPoint:location fromView:nil];
//    NSLog(@"Movement: %@ in %@", NSStringFromPoint(center), NSStringFromRect(self.bounds));
    if ([northPath containsPoint:center]) {
        [appDelegate.modeMap toggleHoverModeDirection:NORTH hovering:hovering];
    } else if ([eastPath containsPoint:center]) {
        [appDelegate.modeMap toggleHoverModeDirection:EAST hovering:hovering];
    } else if ([westPath containsPoint:center]) {
        [appDelegate.modeMap toggleHoverModeDirection:WEST hovering:hovering];
    } else if ([southPath containsPoint:center]) {
        [appDelegate.modeMap toggleHoverModeDirection:SOUTH hovering:hovering];
    } else if (appDelegate.modeMap.hoverModeDirection != NO_DIRECTION) {
        [appDelegate.modeMap toggleHoverModeDirection:NO_DIRECTION hovering:NO];
    }
}

@end
