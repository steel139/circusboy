//
//  JumpPlayer.h
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/06/05.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define PLAYER_START_YPOS 60
#define PLAYER_ADD_JUMP_UP    (3)
#define PLAYER_ADD_JUMP_DOWN  (-2)

static const int JUMP_PLAYER   = 20;

@interface JumpPlayer : CCLayer {
    CCSprite    *mpSprite;      // 炎の輪のスプライトデータ後
    BOOL        IsJumpAdd;      // ジャンプ加速度を加え続けるか？
}

-(id) init;
-(id) init;


@property(readonly) CCSprite   *mpSprite;        // パネルのスプライトデータ
-(void)updata;
-(void)doTouch:(TOUCH_DIRECTION_TAG)iTouchDir TouchPoint:(CGPoint)iTouchPoint withEvent:(UIEvent *)event;
-(void)doRelease:(TOUCH_DIRECTION_TAG)iTouchDir TouchPoint:(CGPoint)iTouchPoint withEvent:(UIEvent *)event;

// ローカル
-(CCSprite *)getObj;
@end
