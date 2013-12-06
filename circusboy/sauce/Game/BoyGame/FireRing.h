//
//  FireRing.h
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/06/05.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

static const int JUMP_FIRE_Z_F = 30;
static const int JUMP_FIRE_Z_B = 10;


// リングを出す位置
typedef enum FIRE_RING_SET_POS {
    FIRE_RING_UP        = 0,
    FIRE_RING_DOWN      ,
    FIRE_RING_POS_MAX
} FIRE_RING_SET_POS;

// リングのサイズ
typedef enum _FIRE_RING_RING_SIZE {
    FIRE_RING_BIG       = 0,
    FIRE_RING_SMALE     ,
    FIRE_RING_SIZE_MAX
} FIRE_RING_RING_SIZE;


@interface FireRing : CCLayer {
    CCSprite                *mpFireRingFlont;   // 炎の輪のスプライトデータ後
    CCSprite                *mpFireRingBack;    // 炎の輪のスプライトデータ前
    CCSprite                *mpBar;             // 炎の輪を支えるバーのスプライトデータ
//    int                     mId;              // の状況
    BOOL                    IsScoreGet;         // 得点を取得したかどうか。
    FIRE_RING_SET_POS       mPosId;             // 出現位置
    FIRE_RING_RING_SIZE     mSizeId;            // リングの大きさ
    float                   mLength;            // 棒の長さ
    float                   mSpeed;             // リングの移動速度
}

// 関数
-(id)initPos:(FIRE_RING_SET_POS)iPos Size:(FIRE_RING_RING_SIZE)iSize Length:(float)iLength Speed:(float)iSpeed; // 初期化
-(void)addChild:(id)iStage;     // シーンに追加
-(BOOL)Move;                    // 移動
-(void)SetPosX:(float)iX Y:(float)iY;
-(int)IsHit:(CGPoint)iPoint;

// ローカル
-(CCSprite *)getObjFlont:(FIRE_RING_RING_SIZE)iSize;
-(CCSprite *)getObjBack:(FIRE_RING_RING_SIZE)iSize;
-(CCSprite *)getObjBar:(FIRE_RING_SET_POS)iPos;


// プロパティ
@property FIRE_RING_SET_POS    mPosId;           // 出現位置
@property FIRE_RING_RING_SIZE  mSizeId;          // リングの大きさ

@end
