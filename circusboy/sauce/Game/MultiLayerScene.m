//
//  MultiLayerScene.m
//  Kopipe-Chapter4
//
//  Created by Sho Tachibana on 11/09/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiLayerScene.h"
#import "InitialScene.h"
#import "LoadingScene.h"
#import "JumpGame.h"
#import "SimpleAudioEngine.h"


@implementation MultiLayerScene

// 自分自身のインスタンスを1つしか生成出来ないようにするコード
static MultiLayerScene *multiLayerSceneInstance;

static GameModeTag sGameModeTag;

// 自分自身への参照を返すメソッド
+(MultiLayerScene*) sharedLayer
{
    return multiLayerSceneInstance;
}

// タグでgameLayerを取得し参照を返す関数
-(GameLayer *) gameLayer
{
    CCNode* layer = [self getChildByTag:LayerTagGame];
    return (GameLayer *)layer;
}

// タグでcontrolLayerを取得し参照を返す関数
-(ControlLayer *) controlLayer
{
    CCNode* layer = [[MultiLayerScene sharedLayer] getChildByTag:LayerTagControl];
    return (ControlLayer *)layer;
}

/*
 +(id) scene
 {
 CCScene* scene = [CCScene node];
 MultiLayerScene* layer = [MultiLayerScene node];
 [scene addChild:layer];
 return scene;
 }
 */

+(id) sceneWithGameModeTag:(GameModeTag)gameModeTag
{
    sGameModeTag = gameModeTag;
    CCScene* scene = [CCScene node];
    MultiLayerScene* layer = [MultiLayerScene node];
    [scene addChild:layer];
    return scene;
}

-(id) init
{
    if ((self = [super init]))
    {

        // 音のいれこみ
//        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"game_bgm.mp3"];

        // 自分自身のインスタンスをmultiLayerSceneInstanceに格納
        multiLayerSceneInstance = self;
        
        // MultiLayerSceneにgameLayerを貼り付け。層は一番下、タグはLayerTagGame
        GameLayer *gameLayer = [GameLayer node];
        [self addChild:gameLayer z:0 tag:LayerTagGame];
        
        // MultiLayerSceneにcontrolLayerを貼り付け。層はgameLayerの上、タグはLayerTagControl
        ControlLayer *controlLayer = [ControlLayer node];
        [self addChild:controlLayer z:1 tag:LayerTagControl];
        
    }
    return self;
}

// -----------------------------------------------------------------------------
// ゲームモードの取得
-(GameModeTag)getGameModeTag
{
    return sGameModeTag;
}

// -----------------------------------------------------------------------------
// タイトルへ移動
-(void)showInitialScene
{
    CCTransitionFade *transition = [CCTransitionFade transitionWithDuration:1.5f scene:[InitialScene scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
}

// -----------------------------------------------------------------------------
// ロード画面に移動
-(void)showLoading
{
    CCTransitionFade *transition = [CCTransitionFade transitionWithDuration:0.4f scene:[LoadingScene sceneWithGameModeTag:sGameModeTag]];
    [[CCDirector sharedDirector] replaceScene:transition];
}


@end
