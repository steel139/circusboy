//
//  FireRing.m
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/06/05.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "FireRing.h"
#import "SimpleAudioEngine.h"


@implementation FireRing

// プロパティ
@synthesize mPosId;           // 出現位置
@synthesize mSizeId;          // リングの大きさ

// 
-(id)initPos:(FIRE_RING_SET_POS)iPos Size:(FIRE_RING_RING_SIZE)iSize Length:(float)iLength Speed:(float)iSpeed
{
    if ((self = [super init]))
    {
        mpFireRingFlont = [self getObjFlont:iSize];   // 炎の輪のスプライトデータ後ろ
        mpFireRingBack  = [self getObjBack:iSize];    // 炎の輪のスプライトデータ前
        mpBar           = [self getObjBar:iPos];    // 炎の輪のスプライトデータ前
        mPosId          = iPos;                                 // 出現位置
        mSizeId         = iSize;                                // リングの大きさ
        mLength         = iLength;                              // 棒の長さ
        mSpeed          = iSpeed;                               // リングの移動速度
        IsScoreGet      = false;
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////
// 追加
-(void)addChild:(id)iStage
{
    [iStage addChild:mpFireRingFlont z:JUMP_FIRE_Z_F];
    [iStage addChild:mpFireRingBack z:JUMP_FIRE_Z_B];
    [iStage addChild:mpBar z:JUMP_FIRE_Z_F];
}

////////////////////////////////////////////////////////////////////////////////
// 移動
-(BOOL)Move
{
    mpFireRingFlont.position = ccp(mpFireRingFlont.position.x - mSpeed, mpFireRingFlont.position.y);
    mpFireRingBack.position  = ccp(mpFireRingBack.position.x - mSpeed, mpFireRingBack.position.y);
    mpBar.position           = ccp(mpBar.position.x - mSpeed, mpBar.position.y);
    

    // リングが画面左端から消えたらステージから取り除く
    const int REMOVE_POS = -48;
    if(mpFireRingFlont.position.x < REMOVE_POS)
    {
        [mpFireRingFlont removeFromParentAndCleanup:YES];
        return true;
    }
    
    return false;

}

////////////////////////////////////////////////////////////////////////////////
// 位置の設定
-(void)SetPosX:(float)iX Y:(float)iY
{
    const int POS_OFFSET_SX = 32;
    const int POS_OFFSET_LX = 32;
    
    // リングの設定

    if(mSizeId == FIRE_RING_BIG)
    {
        // 大きいリング
        mpFireRingFlont.position = ccp(iX+POS_OFFSET_LX, iY);
        mpFireRingBack.position  = ccp(iX, iY);

    
        // バーの設定
        const int POS_OFFSET_BAR_X = 16+4;
        const int POS_OFFSET_UY = 96+44;
        const int POS_OFFSET_DY = -(96+44);
        if(mPosId == FIRE_RING_UP)
        {
            // 上
            mpBar.position = ccp(iX+POS_OFFSET_BAR_X, iY+POS_OFFSET_UY);
        }else {
            // 下
            mpBar.position = ccp(iX+POS_OFFSET_BAR_X, iY+POS_OFFSET_DY);
        }
    }else {
        // 小さいリング
        mpFireRingFlont.position = ccp(iX+POS_OFFSET_SX, iY);
        mpFireRingBack.position  = ccp(iX, iY);

            
        // バーの設定
        const int POS_OFFSET_BAR_X = 16+2;
        const int POS_OFFSET_UY = 96+44-8;
        const int POS_OFFSET_DY = -(96+44-8);
        if(mPosId == FIRE_RING_UP)
        {
            // 上
            mpBar.position = ccp(iX+POS_OFFSET_BAR_X, iY+POS_OFFSET_UY);
        }else {
            // 下
            mpBar.position = ccp(iX+POS_OFFSET_BAR_X, iY+POS_OFFSET_DY);
        }
    }
}



////////////////////////////////////////////////////////////////////////////////
// true = 火の輪にあたった　FALSE= 火の輪に当たっていない
-(int)IsHit:(CGPoint)iPoint
{
    CGPoint aPoint = mpFireRingFlont.position;

    
    if( mSizeId == FIRE_RING_BIG )
    {
        if(aPoint.x-8>iPoint.x &&  (aPoint.x-8)<iPoint.x+8)
        {
            // 下
            if((aPoint.y-40)>iPoint.y &&  (aPoint.y-40)<iPoint.y+32)
            {
                NSLog(@"HIT! %f %f",aPoint.x,iPoint.x);
                return -1;
            }
            
            // 上
            if((aPoint.y+80)>iPoint.y &&  (aPoint.y+80)<iPoint.y+32)
            {
                NSLog(@"HIT! %f %f",aPoint.y,iPoint.y);
                return -1;
            }
            // 得点
            if(IsScoreGet == false){                
                if((aPoint.y-56)<iPoint.y && (aPoint.y+80)>iPoint.y)
                {
                    IsScoreGet = true;
                    [[SimpleAudioEngine sharedEngine] playEffect:@"get_2.m4a"]; 
                    return 100;
                }
            }
        }

            
    }else {
        if(aPoint.x-8>iPoint.x &&  (aPoint.x-8)<iPoint.x+10)
        {
            // 下
            if((aPoint.y-24)>iPoint.y &&  (aPoint.y-24)<iPoint.y+32)
            {
                NSLog(@"HIT! %f %f",aPoint.x,iPoint.x);
                return -1;
            }
            
            // 上
            if((aPoint.y+72)>iPoint.y &&  (aPoint.y+72)<iPoint.y+32)
            {
                NSLog(@"HIT! %f %f",aPoint.y,iPoint.y);
                return -1;
            }

            // 得点
            if(IsScoreGet == false){                
                if((aPoint.y-40)<iPoint.y && (aPoint.y+64)>iPoint.y)
                {
                    IsScoreGet = true;
                    [[SimpleAudioEngine sharedEngine] playEffect:@"get_3.m4a"]; 
                    return 150;
                }
            }
        }
    }
    
    return 0;
}

// 引数からCCSpriteを作成する
// 前取得
-(CCSprite *)getObjFlont:(FIRE_RING_RING_SIZE)iSize
{
    CCSprite *apSprite;
    CCAnimation* aAnimation = [CCAnimation animation];
    switch (iSize)
    {
        case FIRE_RING_BIG:
            apSprite = [CCSprite spriteWithFile:@"fire_b_01_r.png"];
            for(int i = 1; i < 3; i++) {
                [aAnimation addFrameWithFilename: [NSString stringWithFormat:@"fire_b_%02d_r.png", i]];
            }
            break;
        case FIRE_RING_SMALE:
            apSprite = [CCSprite spriteWithFile:@"fire_s_01_r.png"];
            for(int i = 1; i < 3; i++) {
                [aAnimation addFrameWithFilename: [NSString stringWithFormat:@"fire_s_%02d_r.png", i]];
            }
            break;
        case FIRE_RING_SIZE_MAX:
            break;
    }
    
    // 繰り返しを設定し、適用
    CCAnimate *action = [CCAnimate actionWithDuration:0.5f 
                                            animation:aAnimation restoreOriginalFrame:NO];
    id forever = [CCRepeatForever actionWithAction:action];
    [apSprite runAction:forever];
    
    
    return apSprite;
}
// 後ろ取得
-(CCSprite *)getObjBack:(FIRE_RING_RING_SIZE)iSize
{
    CCSprite *apSprite;
    CCAnimation* aAnimation = [CCAnimation animation];
    switch (iSize)
    {
        case FIRE_RING_BIG:
            apSprite = [CCSprite spriteWithFile:@"fire_b_01_l.png"];
            for(int i = 1; i < 3; i++) {
                [aAnimation addFrameWithFilename: [NSString stringWithFormat:@"fire_b_%02d_l.png", i]];
            }
            break;
        case FIRE_RING_SMALE:
            apSprite = [CCSprite spriteWithFile:@"fire_s_01_l.png"];
            for(int i = 1; i < 3; i++) {
                [aAnimation addFrameWithFilename: [NSString stringWithFormat:@"fire_s_%02d_l.png", i]];
            }
            break;
        case FIRE_RING_SIZE_MAX:
            break;
    }
    // 繰り返しを設定し、適用
    CCAnimate *action = [CCAnimate actionWithDuration:0.5f 
                                            animation:aAnimation restoreOriginalFrame:NO];
    id forever = [CCRepeatForever actionWithAction:action];
    [apSprite runAction:forever];

    return apSprite;
}
// バー取得
-(CCSprite *)getObjBar:(FIRE_RING_SET_POS)iPos
{
    CCSprite *apSprite;
    switch (iPos)
    {
        case FIRE_RING_UP:
            apSprite = [CCSprite spriteWithFile:@"kusari.png"];
            break;
        case FIRE_RING_DOWN:
            apSprite = [CCSprite spriteWithFile:@"bou.png"];
            break;
        case FIRE_RING_POS_MAX:
            break;
    }
    return apSprite;
}

    

@end
