//
//  MultiLayerScene.h
//  Kopipe-Chapter4
//
//  Created by Sho Tachibana on 11/09/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "ControlLayer.h"

// 各レイヤーのタグを定義
typedef enum {
    LayerTagGame,
    LayerTagControl,
} MultiLayerSceneTag;

typedef enum
{
    GameModeTagNormalGame,
    GameModeTagTime500,
    GameModeTagTime1000,
    GameModeTagChop10,
    GameModeTagChop30,
    GameModeTagChop1,
    GameModeTagSuddenDeath
} GameModeTag;


@interface MultiLayerScene : CCLayer {
    
}

// 他のクラスへ自分自身の参照を渡すメソッド
+(MultiLayerScene*) sharedLayer;

// 他のクラスへ各レイヤーへの参照を渡すメソッド
@property (readonly) GameLayer *gameLayer;
@property (readonly) ControlLayer *controlLayer;

// MultiLayerSceneをタグ付きでインスタンス化
+(id) sceneWithGameModeTag:(GameModeTag)gameModeTag;
// タグを返す
-(GameModeTag)getGameModeTag;
// 初期化
-(void)showInitialScene;
// ローディング
-(void)showLoading;



@end
