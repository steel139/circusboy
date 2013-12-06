//
//  JumpPlayer.m
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/06/05.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "JumpPlayer.h"
#import "SimpleAudioEngine.h"


@implementation JumpPlayer

// プロパティ
@synthesize mpSprite;        // パネルのスプライトデータ

////////////////////////////////////////////////////////////////////////////////
// 初期化処理
-(id) init;
{
    if ((self = [super init]))
    {
        mpSprite    = [self getObj];   // 炎の輪のスプライトデータ後ろ
        IsJumpAdd   = false;
    }
    return self;
}

-(CCSprite *)getObj
{
    CCSprite *apSprite;
    CCAnimation* aAnimation = [CCAnimation animation];
    apSprite = [CCSprite spriteWithFile:@"hito_1.png"];
    [aAnimation addFrameWithFilename: [NSString stringWithFormat:@"hito_1.png"]];
    [aAnimation addFrameWithFilename: [NSString stringWithFormat:@"hito_2.png"]];
    [aAnimation addFrameWithFilename: [NSString stringWithFormat:@"hito_1.png"]];
    CCAnimate *action = [CCAnimate actionWithDuration:0.5f 
                                            animation:aAnimation restoreOriginalFrame:NO];
    id forever = [CCRepeatForever actionWithAction:action];
    [apSprite runAction:forever];
    
    return apSprite;
}

////////////////////////////////////////////////////////////////////////////////
// 画面をタッチしたときに行う処理
-(void)updata
{
    if( IsJumpAdd == true && mpSprite.position.y<= 300 )
    {
        mpSprite.position = ccp( mpSprite.position.x, mpSprite.position.y+PLAYER_ADD_JUMP_UP);
    }else{
        if( mpSprite.position.y>PLAYER_START_YPOS )
        {
            mpSprite.position = ccp( mpSprite.position.x, mpSprite.position.y+PLAYER_ADD_JUMP_DOWN);
        }else {
            mpSprite.position = ccp( mpSprite.position.x, PLAYER_START_YPOS);
        }
        
    }
}


////////////////////////////////////////////////////////////////////////////////
// 画面をタッチしたときに行う処理
-(void)doTouch:(TOUCH_DIRECTION_TAG)iTouchDir TouchPoint:(CGPoint)iTouchPoint withEvent:(UIEvent *)event
{
    // ジャンプボタンとみなすエリアを定義
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGRect rect = CGRectMake(winSize.width -120 , 00 , 100, 100);
    // 定義した四角形に点が含まれているか計算
    BOOL ret = CGRectContainsPoint(rect , iTouchPoint);

    if (ret==true){
        if(IsJumpAdd==false)
            [[SimpleAudioEngine sharedEngine] playEffect:@"jump_2.m4a"]; 
    }

    IsJumpAdd = ret;
    
    
}
////////////////////////////////////////////////////////////////////////////////
// 指を離したときに行う処理
-(void)doRelease:(TOUCH_DIRECTION_TAG)iTouchDir TouchPoint:(CGPoint)iTouchPoint withEvent:(UIEvent *)event
{
    IsJumpAdd = false;
}
    































@end
