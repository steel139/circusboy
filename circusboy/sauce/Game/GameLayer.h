//
//  GameLayer.h
//  Kopipe-Chapter4
//
//  Created by Sho Tachibana on 11/09/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "JumpGame.h"



@interface GameLayer : CCLayer {


// boxの定数
#define BOX_STERT_COL_NUM 4
#define BOX_ROW_NODELETE_BOTTOM_NUM 2
#define BOX_ROW_NUM 9
#define BOX_COL_NUM 4
#define BOX_UP_TIME    3.0f
    
    
// BGの定数
#define BGZ_INDEX_Z 10
    
// keyの定数
#define KEY_ROW_NUM 4
    

    ////////////////////////////////////////////////////////////////////////////
    // Minesweeper
    JumpGame* mpJump;
    
    
    ////////////////////////////////////////////////////////////////////////////
    // CharaCube
    CCSprite        *mBgCharaCube;                          // BG

    CCArray         *mpBoxArray[BOX_COL_NUM];              // Boxデータ。二次元配列で用意する。
    CCArray         *mpKeyArray;                            // Boxデータ。二次元配列で用意する。
    int             mKeyDataArray[KEY_ROW_NUM];             // keyデータ
    CGPoint         mMoveTarget;
    
    CCSprite    *mpAnimBg;
    
    ccTime totalTime;
    
    // 得点
    int score;
    
    // 得点ラベル
    CCLabelTTF *scoreLabel;

    // メニューのタップ可否
    BOOL isMenuReady;

    // ゲームオーバー画面が表示されているか
    BOOL isSubLayerExists;
}

// 画面がタップされた時に実行される関数
//-(void)doTouch:(UITouch *)touch withEvent:(UIEvent *)event;
-(void)doTouchBoxWhisDir:(TOUCH_DIRECTION_TAG)iTouchDir   TouchPoint:(CGPoint)iTouchPoint withEvent:(UIEvent *)event;
-(void)doReleaseWhisDir:(TOUCH_DIRECTION_TAG)iTouchDir    TouchPoint:(CGPoint)iTouchPoint withEvent:(UIEvent *)event;
-(void)doTouchMovedWhisDir:(TOUCH_DIRECTION_TAG)iTouchDir TouchPoint:(CGPoint)iTouchPoint withEvent:(UIEvent *)event;

////////////////////////////////////////////////////////////////////////////////
//システム関数
// ゲームを一時中断する
-(void)pauseGame;
// 中断したゲームを再開する
-(void)resumeGame;


@end
