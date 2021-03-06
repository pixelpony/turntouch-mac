//
//  TTDiamond.h
//  Turn Touch Remote
//
//  Created by Samuel Clay on 8/21/13.
//  Copyright (c) 2013 Turn Touch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TTModeDirection.h"
#import "TTMode.h"
#import "TTBatchActions.h"

@class TTMode;
@class TTAction;
@class TTBatchActions;

@interface TTModeMap : NSObject {
    BOOL waitingForDoubleClick;
}

@property (nonatomic, assign) TTModeDirection activeModeDirection;
@property (nonatomic, assign) TTModeDirection selectedModeDirection;
@property (nonatomic, assign) TTModeDirection inspectingModeDirection;
@property (nonatomic, assign) TTModeDirection hoverModeDirection;
@property (nonatomic, assign) NSString *tempModeName;
@property (nonatomic, assign) BOOL openedModeChangeMenu;
@property (nonatomic, assign) BOOL openedActionChangeMenu;
@property (nonatomic, assign) BOOL openedAddActionChangeMenu;
@property (nonatomic, assign) BOOL openedChangeActionMenu;
@property (nonatomic) TTMode *selectedMode;
@property (nonatomic) TTMode *northMode;
@property (nonatomic) TTMode *eastMode;
@property (nonatomic) TTMode *westMode;
@property (nonatomic) TTMode *southMode;
@property (nonatomic) TTMode *tempMode;
@property (nonatomic) TTAction *batchActionChangeAction;
@property (nonatomic) TTBatchActions *batchActions;
@property (nonatomic) NSArray *availableModes;
@property (nonatomic) NSArray *availableActions;
@property (nonatomic) NSArray *availableAddModes;
@property (nonatomic) NSArray *availableAddActions;

- (void)activateTimers;
- (void)switchMode;
- (void)switchMode:(TTModeDirection)direction modeName:(NSString *)modeName;
- (void)reset;
- (void)maybeFireActiveButton;
- (void)runActiveButton;
- (void)runDirection:(TTModeDirection)direction;
- (void)runDoubleButton:(TTModeDirection)direction;

- (BOOL)shouldHideHud:(TTModeDirection)direction;
- (NSString *)directionName:(TTModeDirection)direction;
- (TTMode *)modeInDirection:(TTModeDirection)direction;
- (void)changeDirection:(TTModeDirection)direction toMode:(NSString *)modeClassName;
- (void)changeDirection:(TTModeDirection)direction toAction:(NSString *)actionClassName;
- (void)addBatchAction:(NSString *)actionName;
- (void)changeBatchAction:(NSString *)batchActionKey toAction:(NSString *)actionName;
- (void)removeBatchAction:(NSString *)batchActionKey;
- (NSArray *)selectedModeBatchActions:(TTModeDirection)direction;

- (void)changeModeOption:(NSString *)optionName to:(id)optionValue;
- (void)changeMode:(TTMode *)mode option:(NSString *)optionName to:(id)optionValue;
- (void)changeActionOption:(NSString *)optionName to:(id)optionValue;
- (void)changeActionOption:(NSString *)optionName to:(id)optionValue direction:(TTModeDirection)direction;
- (void)changeMode:(TTMode *)mode actionOption:(NSString *)optionName to:(id)optionValue direction:(TTModeDirection)direction;
- (void)changeMode:(TTMode *)mode batchActionKey:(NSString *)batchActionKey
      actionOption:(NSString *)optionName to:(id)optionValue direction:(TTModeDirection)direction;
- (id)modeOptionValue:(NSString *)optionName;
- (id)mode:(TTMode *)mode optionValue:(NSString *)optionName;
- (id)actionOptionValue:(NSString *)optionName;
- (id)actionOptionValue:(NSString *)optionName inDirection:(TTModeDirection)direction;
- (id)mode:(TTMode *)mode actionOptionValue:(NSString *)optionName inDirection:(TTModeDirection)direction;
- (id)mode:(TTMode *)mode actionOptionValue:(NSString *)optionName actionName:(NSString *)actionName inDirection:(TTModeDirection)direction;
- (id)mode:(TTMode *)mode batchAction:(TTAction *)action
actionOptionValue:(NSString *)optionName inDirection:(TTModeDirection)direction;
- (void)toggleInspectingModeDirection:(TTModeDirection)direction;
- (void)toggleHoverModeDirection:(TTModeDirection)direction hovering:(BOOL)hovering;

- (void)recordUsageMoment:(NSString *)moment;
- (void)recordUsage:(NSDictionary *)additionalParams;
- (NSDictionary *)deviceAttrs;
- (NSString *)userId;
- (NSString *)deviceId;

@end
