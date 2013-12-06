//
//  JumpGame.m
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/06/05.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "JumpGame.h"
#import "FireRing.h"
#import "JumpPlayer.h"
#import "SimpleAudioEngine.h"


@implementation JumpGame

// プロパティー
@synthesize mpJumpPlayer;      // プレヤークラス
@synthesize IsStop;
@synthesize mScore;

const int YUKA_SET_HIGHT = 16;  // 床の高さ

-(void) init:(id)sender;
{
    mpStage = sender;
    IsStop  = false;

    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    mpBgBack = [CCSprite spriteWithFile:@"yuka.png"];
    mpBgBack.position = ccp(winSize.width / 2, YUKA_SET_HIGHT);
    [mpStage addChild:mpBgBack z:0 ];
    mpBgFlont = [CCSprite spriteWithFile:@"yuka.png"];
    mpBgFlont.position = ccp(winSize.width / 2, 0);
    [mpStage addChild:mpBgFlont z:40 ];
    
    
    // 炎が流れる速度を指定
    mFireVelocity = 0.3f;
    // 炎が出現する頻度を設定
    mFireAppearDuration = 6.0f;
    
    // 配列を初期化
    mpFireArray = [[CCArray alloc] initWithCapacity:0];

    // 炎を出現させる関数setNewFireを呼び出し
    [self performSelector:@selector(setNewFire:) withObject:self];

    // プレイヤーキャラクターの生成と登録
    mpJumpPlayer = [[JumpPlayer alloc] init];
    mpJumpPlayer.mpSprite.position = ccp(100, PLAYER_START_YPOS);
    [mpStage addChild:mpJumpPlayer.mpSprite z:JUMP_PLAYER];
    
    // Jumpボタン
    CCSprite *apSprite;
    CCAnimation* aAnimation = [CCAnimation animation];
    apSprite = [CCSprite spriteWithFile:@"btn_jump.png"];
    [aAnimation addFrameWithFilename: [NSString stringWithFormat:@"btn_jump.png"]];
    [aAnimation addFrameWithFilename: [NSString stringWithFormat:@"btn_jump_1.png"]];
    [aAnimation addFrameWithFilename: [NSString stringWithFormat:@"btn_jump.png"]];
    [aAnimation addFrameWithFilename: [NSString stringWithFormat:@"btn_jump.png"]];
    [aAnimation addFrameWithFilename: [NSString stringWithFormat:@"btn_jump.png"]];
    CCAnimate *action = [CCAnimate actionWithDuration:2.0f 
                                            animation:aAnimation restoreOriginalFrame:NO];
    id forever = [CCRepeatForever actionWithAction:action];
    [apSprite runAction:forever];
    
    apSprite.position = ccp( 390, 50);
    [mpStage addChild:apSprite z:41 ];
    
}

-(void)setNewFire:(id)sender
{
    // 停止中は処理をしない。
    if(IsStop)
        return ;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int iPos        = arc4random() % 2;
    int iSize       = arc4random() % 2;
    float iLength   = (arc4random()%10)*8+120;
    float aHoge     = 1.5f+(mTotalTime/30.0f);
    float iSpeed    = (float)(arc4random() % 100)/100.0f+aHoge;
    if(iLength > winSize.height/2)
    {
        iPos = FIRE_RING_UP;
    } else {
        iPos = FIRE_RING_DOWN;
    }
        

    // 火の輪を作る。
    FireRing *pFire;
    pFire = [FireRing alloc];
    [pFire initPos:iPos Size:iSize Length:iLength Speed:iSpeed];
    // 位置を設定する
    [pFire SetPosX:winSize.width Y: iLength];
    // 配列に格納
    [mpFireArray addObject:pFire];
    // ステージに貼り付け
    [pFire addChild:mpStage];

    // 指定された秒数語に再度呼び出し
    mFireAppearDuration = mFireAppearDuration-(mTotalTime/30.0f);
    if(mFireAppearDuration < 1.0f)
        mFireAppearDuration = 2.5f; 
    
    //    [mpStage performSelector:@selector(setNewFire:) withObject:self afterDelay:mFireAppearDuration];
    [self performSelector:@selector(setNewFire:) withObject:self afterDelay:mFireAppearDuration];
}

-(void)stopNewFire
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setNewFire:) object:self];
}
-(void)setNewFire_
{
    [self performSelector:@selector(setNewFire:) withObject:self afterDelay:mFireAppearDuration];
}


-(BOOL) update:(ccTime)delta
{
    // 経過時間を追加
    mTotalTime += delta;
    
    // プレイヤーアップデート
    [mpJumpPlayer updata];

    // vegetableVelocity分だけ移動
    for(FireRing *pFireRing in mpFireArray)
    {
        int aScore = [pFireRing IsHit:mpJumpPlayer.mpSprite.position];
        if(aScore==-1)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"fail.m4a"]; 

           // ゲームオーバー
           return false;
            
        }else
        if(aScore>0)
        {
            // スコア加算
            mScore += aScore;
            
        }

        BOOL aRes = [pFireRing Move];
        // 画面端まで届いたら配列から削除を行う
        if(aRes == TRUE)
            [mpFireArray removeObject:pFireRing];
        
    }
 
    return true;
}

// 画面がタップされた時に実行される関数
// (UIEvent *)eventは渡されるが使用していない。 
-(void)doTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"%@", @"doTouch");
}


-(void)removeAndCleanUpObject:(id)sender
{
    [(CCSprite *)sender removeFromParentAndCleanup:YES];
}

// 得点の加算
-(void)addScore:(id)sender
{
    mScore += 1;
}



















@end
