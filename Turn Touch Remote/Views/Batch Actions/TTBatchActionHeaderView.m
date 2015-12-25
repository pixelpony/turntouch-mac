//
//  TTBatchActionHeaderView.m
//  Turn Touch Remote
//
//  Created by Samuel Clay on 12/20/15.
//  Copyright © 2015 Turn Touch. All rights reserved.
//

#import "TTBatchActionHeaderView.h"

#define BATCH_ACTION_HEADER_MARGIN 13.f
#define BATCH_ACTION_HEADER_PADDING 4.f

@implementation TTBatchActionHeaderView

@synthesize mode;
@synthesize batchAction;

- (instancetype)initWithTempMode:(TTMode *)_mode {
    if (self = [super init]) {
        appDelegate = (TTAppDelegate *)[NSApp delegate];
        batchAction = nil;
        mode = _mode;
        
        [self setupLabels];
    }
    
    return self;
}

- (instancetype)initWithBatchAction:(TTAction *)_batchAction {
    if (self = [super init]) {
        appDelegate = (TTAppDelegate *)[NSApp delegate];
        batchAction = _batchAction;
        mode = batchAction.mode;
        
        [self setupLabels];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Background
//    [NSColorFromRGB(0xFFFFFF) set];
//    NSRectFill(self.bounds);
    
    // Mode image
    NSString *imageFilename = [[mode class] imageName];
    NSString *imagePath = [NSString stringWithFormat:@"%@/icons/%@", [[NSBundle mainBundle] resourcePath], imageFilename];
    modeImage = [[NSImage alloc] initWithContentsOfFile:imagePath];
    
    [modeImage setSize:NSMakeSize(22, 22)];
    CGFloat offset = (NSHeight(self.frame)/2) - (modeImage.size.height/2);
    NSPoint imagePoint = NSMakePoint(BATCH_ACTION_HEADER_MARGIN, offset);
    NSRect imageRect = NSMakeRect(imagePoint.x, imagePoint.y,
                                  modeImage.size.width, modeImage.size.height);
    [modeImage drawInRect:imageRect];
    
    // Mode name
    NSSize titleSize = [[[mode class] title] sizeWithAttributes:titleAttributes];
    NSPoint titlePoint = NSMakePoint(NSMaxX(imageRect) + BATCH_ACTION_HEADER_MARGIN,
                                     NSHeight(self.frame)/2 - floor(titleSize.height/2) + 1);
    
    [[[mode class] title] drawAtPoint:titlePoint withAttributes:titleAttributes];

    if (!batchAction) return;
    
    // Action title
    NSString *actionName = [mode titleForAction:batchAction.actionName buttonAction:BUTTON_ACTION_PRESSUP];
    NSSize actionSize = [actionName sizeWithAttributes:titleAttributes];
    NSPoint actionPoint = NSMakePoint(NSMinX(self.frame) + BATCH_ACTION_HEADER_MARGIN + 112,
                                      NSHeight(self.frame)/2 - floor(actionSize.height/2) + 1);
    
    // Delete button
    NSSize deleteSize = NSMakeSize(NSHeight(self.frame)/2 + BATCH_ACTION_HEADER_PADDING*2,
                                   NSHeight(self.frame)/2 + BATCH_ACTION_HEADER_PADDING*2);
    NSPoint deletePoint = NSMakePoint(NSMaxX(self.bounds) - deleteSize.width - BATCH_ACTION_HEADER_MARGIN,
                                      NSHeight(self.bounds)/2 - floor(deleteSize.height/2));
    if (deleteButton) {
        [deleteButton removeFromSuperview];
        deleteButton = nil;
    }
    deleteButton = [[TTChangeButtonView alloc] initWithFrame:NSMakeRect(deletePoint.x, deletePoint.y, deleteSize.width, deleteSize.height)];
    NSString *imageFile = [NSString stringWithFormat:@"%@/icons/button_dash.png", [[NSBundle mainBundle] resourcePath]];
    NSImage *icon = [[NSImage alloc] initWithContentsOfFile:imageFile];
    [icon setSize:NSMakeSize(13, 13)];
    [deleteButton setImage:icon];
    [deleteButton setImagePosition:NSImageOnly];
    [deleteButton setTitle:@""];
    [deleteButton setUseAltStyle:YES];
    [deleteButton setBezelStyle:NSRoundRectBezelStyle];
    [deleteButton setAction:@selector(deleteBatchAction:)];
    [deleteButton setTarget:self];
    [deleteButton setBorderRadius:4.f];
    [self addSubview:deleteButton];
    
    // Action dropdown
    NSBezierPath *actionPath = [NSBezierPath bezierPath];
    CGFloat xLeft = actionPoint.x - 16;
    CGFloat xRight = deletePoint.x - BATCH_ACTION_HEADER_MARGIN;
    CGFloat yTop = NSMaxY(self.bounds) - BATCH_ACTION_HEADER_PADDING;
    CGFloat yBottom = NSMinY(self.bounds) + BATCH_ACTION_HEADER_PADDING;
    NSRect actionRect = NSInsetRect(NSMakeRect(xLeft, yBottom, xRight - xLeft, yTop - yBottom), 1, 1);
    CGFloat cornerRadius = NSHeight(actionRect)/2;
    [actionPath appendBezierPathWithRoundedRect:actionRect xRadius:cornerRadius yRadius:cornerRadius];
    [actionPath closePath];
    [NSColorFromRGB(0xC2CBCE) set];
    [actionPath setLineWidth:1];
    [actionPath stroke];
    
    [NSColorFromRGB(0xFFFFFF) set];
    [actionPath fill];
    
    [actionName drawAtPoint:actionPoint withAttributes:titleAttributes];
    

    // Action dropdown button
    [NSGraphicsContext saveGraphicsState];
    if (actionButton) {
        [actionButton removeFromSuperview];
        actionButton = nil;
    }
    actionButton = [[TTChangeButtonView alloc] initWithFrame:NSMakeRect(NSMaxX(actionRect) - NSHeight(actionRect),
                                                                        NSMinY(actionRect) - .5f,
                                                                        NSHeight(actionRect) + 1.f,
                                                                        NSHeight(actionRect) + 1.f)];
    NSString *chevronFile = [NSString stringWithFormat:@"%@/icons/button_chevron.png", [[NSBundle mainBundle] resourcePath]];
    NSImage *chevron = [[NSImage alloc] initWithContentsOfFile:chevronFile];
    [chevron setSize:NSMakeSize(13, 13)];
    [actionButton setImage:chevron];
    [actionButton setImagePosition:NSImageOnly];
    [actionButton setTitle:@""];
    [actionButton setUseAltStyle:NO];
    [actionButton setBezelStyle:NSRoundRectBezelStyle];
    [actionButton setAction:@selector(deleteBatchAction:)];
    [actionButton setTarget:self];
    [actionButton setBorderRadius:0.f];
    [self addSubview:actionButton];
    [actionPath addClip];
    [NSGraphicsContext restoreGraphicsState];
}

- (void)setupLabels {
    NSShadow *stringShadow = [[NSShadow alloc] init];
    stringShadow.shadowColor = [NSColor whiteColor];
    stringShadow.shadowOffset = NSMakeSize(0, -1);
    stringShadow.shadowBlurRadius = 0;
    NSColor *textColor = NSColorFromRGB(0x404A60);
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSCenterTextAlignment];
    titleAttributes = @{NSFontAttributeName:[NSFont fontWithName:@"Effra" size:13],
                        NSForegroundColorAttributeName: textColor,
                        NSShadowAttributeName: stringShadow,
                        NSParagraphStyleAttributeName: style
                        };
}

- (IBAction)deleteBatchAction:(id)sender {
    
}

@end
