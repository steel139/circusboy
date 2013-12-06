//
//  JumpGame.h
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/06/05.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "JumpPlayer.h"

@interface JumpGame : CCLayer {
    id          mpStage;            // ステージのポインタ
    CCSprite    *mpBgBack;          // 背景
    CCSprite    *mpBgFlont;         // 背景
    ccTime      mTotalTime;         // 経過時間
    CCArray     *mpFireArray;       // 流れている火の輪を格納する配列
    JumpPlayer  *mpJumpPlayer;      // プレヤークラス

    float       mFireVelocity;      // 火の輪が流れる速度
    float       mFireAppearDuration;// 火の輪が出現する頻度
    int         mContinuous;        // 連続成功数
    int         mScore;             // 得点
    BOOL        IsStop;            // リトライ中
}



-(void) init:(id)sender;
-(BOOL) update:(ccTime)delta;
-(void) stopNewFire;
-(void) setNewFire_;


@property(readonly)    JumpPlayer  *mpJumpPlayer;      // プレヤークラス
@property    BOOL  IsStop; 
@property    int  mScore; 


@end
