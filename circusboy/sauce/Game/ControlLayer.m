//
//  ControlLayer.m
//  Kopipe-Chapter4
//
//  Created by Sho Tachibana on 11/09/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ControlLayer.h"
#import "MultiLayerScene.h"
#import "GameLayer.h"

@implementation ControlLayer

-(id) init
{
    if ((self = [super init]))
    {
        // タッチの検出を可能にする
        self.isTouchEnabled = YES;
        // タッチされるとこのクラス内のccTouch...で始まる関数を実行
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    return self;
}

// タッチディレクターを介してタッチ情報を取得する。
////////////////////////////////////////////////////////////////////////////////
// タッチされた瞬間に一度だけ実行される
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // タッチが始まった座標を得る。画面左下端が(0,0)、右上端が(320,480)となるよう調整 (cocos2Dのデフォルトに合わすための処理
    mTouchStartPoint = ccp([self convertTouchToNodeSpaceAR:touch].x + winSize.width / 2,
                          [self convertTouchToNodeSpaceAR:touch].y + winSize.height / 2);
    
    // 座標の変換
    mTouchPoint = [touch locationInView:[touch view]];
    mTouchPoint = [[CCDirector sharedDirector] convertToGL:mTouchPoint];

    // ゲームレイヤーに送る
    [[[MultiLayerScene sharedLayer] gameLayer] doTouchBoxWhisDir:TOUCH_DIRECTION_RIGHT TouchPoint:mTouchPoint withEvent:event];
    
    return YES;
}
-(void)onResumePressed:(id)sender
{
    // 再度タッチを有効にする
    self.isTouchEnabled = YES;
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    // ポーズ画面を消去
    [self removeChildByTag:TAG_PAUSE_LAYER cleanup:YES];
    
    GameLayer *gameLayer = [[MultiLayerScene sharedLayer] gameLayer];
    [gameLayer resumeGame];
}


// -----------------------------------------------------------------------------
// リトライの実装
// ゲームを初めから開始する
-(void)onRetryPressed:(id)sender
{
    [[CCDirector sharedDirector] resume];       // resume=pouse解除
    MultiLayerScene *multiLayerInstance = [MultiLayerScene sharedLayer];
    [multiLayerInstance showLoading];
    
}

// -----------------------------------------------------------------------------
// タイトルへ戻るの実装
// ゲーム途中からタイトルに戻る
-(void)onGoToTopPressed:(id)sender
{
    [[CCDirector sharedDirector] resume];       // resume=pouse解除
    MultiLayerScene *multiLayerInstance = [MultiLayerScene sharedLayer];
    [multiLayerInstance showInitialScene];
   
}




////////////////////////////////////////////////////////////////////////////////
// マウス(実機の場合は指)が画面を触っている状態で動くとその度実行される
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
//    CCLOG(@"ccTouchMoved");
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint touchPoint = ccp([self convertTouchToNodeSpaceAR:touch].x + winSize.width / 2,
                             [self convertTouchToNodeSpaceAR:touch].y + winSize.height / 2);
    [[[MultiLayerScene sharedLayer] gameLayer] doTouchMovedWhisDir:TOUCH_DIRECTION_RIGHT TouchPoint:touchPoint withEvent:event];
    
}

////////////////////////////////////////////////////////////////////////////////
// タッチが離れた瞬間に一度だけ実行される
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //    CCLOG(@"ccTouchEnded");
    // タッチが終わった座標を得る。
    // 始まった点の座標と終わった点の座標の距離と角度を求めフリックを分類する（座標の指定。　上記と同じコード。cocos2dを使う場合は基本のコードかな。
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint touchEndPoint = ccp([self convertTouchToNodeSpaceAR:touch].x + winSize.width / 2,
                                [self convertTouchToNodeSpaceAR:touch].y + winSize.height / 2);
    
    [[[MultiLayerScene sharedLayer] gameLayer] doReleaseWhisDir:TOUCH_DIRECTION_RIGHT TouchPoint:touchEndPoint withEvent:event];

}




////////////////////////////////////////////////////////////////////////////////
// その他関数
// タッチディレクターの削除
-(void)removeTouchDispatcher
{
    self.isTouchEnabled = NO;
    [[CCTouchDispatcher sharedDispatcher] removeAllDelegates];
}

@end
