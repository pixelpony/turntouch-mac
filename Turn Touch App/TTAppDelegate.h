//
//  TTAppDelegate.h
//  Turn Touch App
//
//  Created by Samuel Clay on 8/1/13.
//  Copyright (c) 2013 Turn Touch. All rights reserved.
//

#import "TTModeDirection.h"
#import "TTMenubarController.h"
#import "TTPanelDelegate.h"
#import "TTPanelController.h"
#import "TTSerialMonitor.h"
#import "TTModeMap.h"
#import "TTHUDController.h"

@class TTModeMap;
@class TTPanelController;
@class TTHUDController;

#define OPEN_DURATION 0.42f

@interface TTAppDelegate : NSObject
<NSApplicationDelegate, TTPanelControllerDelegate>

@property (nonatomic, strong) TTMenubarController *menubarController;
@property (nonatomic, strong, readonly) TTPanelController *panelController;
@property (nonatomic) TTSerialMonitor *serialMonitor;
@property (nonatomic) TTModeMap *modeMap;
@property (nonatomic) TTHUDController *hudController;

- (IBAction)togglePanel:(id)sender;

@end
