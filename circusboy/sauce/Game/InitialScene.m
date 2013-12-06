//
//  InitialScene.m
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/05/11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitialScene.h"
#import "JumpGame.h"
#import "GameLayer.h"
#import "MultiLayerScene.h"
#import "SettingScene.h"
#import "SavedDataHandler.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "SimpleAudioEngine.h"

// ゲームセンター
#import "GameKit/GkScore.h"
#import "GameKit/GKLeaderboardViewController.h"

@implementation InitialScene


+(id) scene
{
    CCScene* scene = [CCScene node];
    InitialScene* layer = [InitialScene node];
    [scene addChild:layer];
    return scene;
}

// サブレイヤーが表示されているかどうかのBOOL
BOOL isSubLayerExist;

-(id) init
{
    if ((self = [super init]))
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];

        // BGの貼りつけ
        CCSprite *bg = [CCSprite spriteWithFile:@"title_circus.png"];
        bg.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:bg];

        // スタートの表示
        CCMenuItemImage *main = [CCMenuItemImage itemFromNormalImage:@"hito_1.png" selectedImage:@"hito_2.png" target:self selector:@selector(onBtnOnSubLayerPressed:)];
        CCMenu *menu0 = [CCMenu menuWithItems:main, nil];
        [menu0 alignItemsVerticallyWithPadding:0.0f];
        menu0.position = ccp(winSize.width / 2-16, winSize.height/ 2-16);
        [self addChild:menu0];
        
        CCMenuItem *item00 = [CCMenuItemImage itemFromNormalImage:@"eroisukauta.png" selectedImage:@"eroisukauta.png" target:self selector:@selector(onLink0:)];
        CCMenuItem *item01 = [CCMenuItemImage itemFromNormalImage:@"kabunusiyuutai.png" selectedImage:@"kabunusiyuutai.png" target:self selector:@selector(onLink1:)];
        CCMenuItem *item02 = [CCMenuItemImage itemFromNormalImage:@"nekosagasi.png" selectedImage:@"nekosagasi.png" target:self selector:@selector(onLink2:)];
        CCMenuItem *item03 = [CCMenuItemImage itemFromNormalImage:@"sonnatokiha.png" selectedImage:@"sonnatokiha.png" target:self selector:@selector(onLink3:)];
        CCMenuItem *item04 = [CCMenuItemImage itemFromNormalImage:@"apps.png" selectedImage:@"apps.png" target:self selector:@selector(onLink4:)];
        CCMenuItem *item05 = [CCMenuItemImage itemFromNormalImage:@"ranking.png" selectedImage:@"ranking.png" target:self selector:@selector(onLink5:)];
        
        CCMenu *menu1 = [CCMenu menuWithItems:item00,item01,item02,item03,item04,item05, nil];
        [menu1 alignItemsHorizontallyWithPadding:10.0f];
        menu1.position = ccp(winSize.width / 2-25.0f, 50.0f);
        [self addChild:menu1 z:1];
        
        

        ////////////////////////////////////////////////////////////////////////
        // ハイスコアの表示
        timeLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:25];
        timeLabel.anchorPoint = CGPointMake(1.0f, 0.5f);
        timeLabel.color = ccc3(255, 0, 0);
        [timeLabel setContentSize:CGSizeMake(120, timeLabel.contentSize.height)];
        timeLabel.position = ccp(winSize.width - timeLabel.contentSize.width / 2 , winSize.height - timeLabel.contentSize.height / 2 - 15);
        int aHiScoar = [[SavedDataHandler sharedSetting] getHiScoar];
        [timeLabel setString:[NSString stringWithFormat:@"HI SCOAE %@", [NSString stringWithFormat:@"%d", aHiScoar]]];
        [self addChild:timeLabel z:50];

        
        isSubLayerExist = NO;
    }
    return self;
}

-(void)onSettingPressed:(id)sender
{
    CCTransitionTurnOffTiles *t = [CCTransitionTurnOffTiles transitionWithDuration:1.0f scene:[SettingScene scene]];
    [[CCDirector sharedDirector] replaceScene:t];
}
/*
-(void)onHelpPressed:(id)sender
{
    CCTransitionTurnOffTiles *t = [CCTransitionTurnOffTiles transitionWithDuration:1.0f scene:[HelpScene scene]];
    [[CCDirector sharedDirector] replaceScene:t];
}
*/
//上から下に滑り落ちてくるアニメーション
-(void)pushObjectFromTop:(id)sender
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *obj = (CCSprite *)sender;
    
    CCMoveTo *action = [CCMoveTo actionWithDuration:1.0f position:CGPointMake(obj.position.x, obj.position.y - winSize.height)];
    CCEaseBounceOut *easeInOut = [CCEaseBounceOut actionWithAction:action];
    
    [obj runAction:easeInOut];
}

// 右から左へ流れてきて、その後バウンドを続けるアニメーション
-(void)pushObjectFromRight:(id)sender
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *obj = (CCSprite *)sender;
    
    CCMoveTo *action = [CCMoveTo actionWithDuration:1.0f position:CGPointMake(winSize.width / 2, obj.position.y)];
    CCEaseBounceOut *easeInOut = [CCEaseBounceOut actionWithAction:action];
    
    CCMoveTo *move = [CCMoveTo actionWithDuration:0.5f position:CGPointMake(winSize.width / 2, obj.position.y + 6)];
    CCMoveTo *moveBack = [CCMoveTo actionWithDuration:0.5f position:CGPointMake(winSize.width / 2, obj.position.y)];
    CCSequence *moveSeq = [CCSequence actions:move, moveBack, nil];
    CCEaseBounceOut *easeInOutMove = [CCEaseBounceOut actionWithAction:moveSeq];
    CCRepeat *repeat = [CCRepeat actionWithAction:easeInOutMove times:100];
    
    [obj runAction:[CCSequence actions:easeInOut,repeat, nil]];
    
}

// タイムアタックボタン押下時、ノルマを選択するサブレイヤーを表示
-(void)onBtn1Pressed:(id)sender
{
    if(isSubLayerExist) return;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCLayerColor *subLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 180)];
    subLayer.isTouchEnabled = YES;
    CCMenuItem *back = [CCMenuItemImage itemFromNormalImage:@"sub_back.png" selectedImage:@"sub_back_p.png" target:self selector:@selector(onBackPressed:)];
    back.position = ccp(-160, 120);
    CCMenuItem *btn1 = [CCMenuItemImage itemFromNormalImage:@"sub_time_100.png" selectedImage:@"sub_time_100_p.png" target:self selector:@selector(onBtnOnSubLayerPressed:)];
    btn1.tag = ObjectTagBtnNormalGame;
    btn1.position = ccp(-15, 40);
    CCMenuItemImage *btn2 = [CCMenuItemImage itemFromNormalImage:@"sub_time_500.png" selectedImage:@"sub_time_500_p.png" target:self selector:@selector(onBtnOnSubLayerPressed:)];
    btn2.tag = ObjectTagBtnTime500;
    btn2.position = ccp(20, -10);
    CCMenuItemImage *btn3 = [CCMenuItemImage itemFromNormalImage:@"sub_time_1000.png" selectedImage:@"sub_time_1000_p.png" target:self selector:@selector(onBtnOnSubLayerPressed:)];
    btn3.tag = ObjectTagBtnTime1000;
    btn3.position = ccp(40, -60);
    CCMenu *menu = [CCMenu menuWithItems:back, btn1, btn2, btn3, nil];
    menu.contentSize = CGSizeMake(winSize.width, winSize.height);
    menu.position = ccp(winSize.width / 2, winSize.height / 2);
    [subLayer addChild:menu];
    
    [self addChild:subLayer z:0 tag:ObjectTagSubLayer];
    isSubLayerExist = YES;
}

// ポイントマッチボタン押下時、秒数を選択するサブレイヤーを表示
-(void)onBtn2Pressed:(id)sender
{
    if(isSubLayerExist) return;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCLayerColor *subLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 180)];
    subLayer.isTouchEnabled = YES;
    CCMenuItem *back = [CCMenuItemImage itemFromNormalImage:@"sub_back.png" selectedImage:@"sub_back_p.png" target:self selector:@selector(onBackPressed:)];
    back.position = ccp(-160, 120);
    CCMenuItem *btn1 = [CCMenuItemImage itemFromNormalImage:@"sub_chop_10.png" selectedImage:@"sub_chop_10_p.png" target:self selector:@selector(onBtnOnSubLayerPressed:)];
    btn1.tag = ObjectTagBtnChop10;
    btn1.position = ccp(-15, 40);
    CCMenuItemImage *btn2 = [CCMenuItemImage itemFromNormalImage:@"sub_chop_30.png" selectedImage:@"sub_chop_30_p.png" target:self selector:@selector(onBtnOnSubLayerPressed:)];
    btn2.tag = ObjectTagBtnChop30;
    btn2.position = ccp(20, -10);
    CCMenuItemImage *btn3 = [CCMenuItemImage itemFromNormalImage:@"sub_chop_1.png" selectedImage:@"sub_chop_1.png" target:self selector:@selector(onBtnOnSubLayerPressed:)];
    btn3.tag = ObjectTagBtnChop1;
    btn3.position = ccp(40, -60);
    CCMenu *menu = [CCMenu menuWithItems:back, btn1, btn2, btn3, nil];
    menu.contentSize = CGSizeMake(winSize.width, winSize.height);
    menu.position = ccp(winSize.width / 2, winSize.height / 2);
    [subLayer addChild:menu];
    
    [self addChild:subLayer z:0 tag:ObjectTagSubLayer];
    isSubLayerExist = YES;
}

// サドンデスモードで起動
-(void)onBtn3Pressed:(id)sender
{
    if(isSubLayerExist) return;
    
//    CCTransitionTurnOffTiles *transition = [CCTransitionTurnOffTiles transitionWithDuration:1.0f scene:[MultiLayerScene sceneWithGameModeTag:GameModeTagSuddenDeath]];
//    [[CCDirector sharedDirector] replaceScene:transition];
}

// サブレイヤー上のバックボタンが押された時、サブレイヤーを削除
-(void) onBackPressed:(id) sender
{
    [self removeChildByTag:ObjectTagSubLayer cleanup:YES];
    
    isSubLayerExist = NO;
}

// サブレイヤー上のボタンが押された時、押されたボタンのタグによってゲームモードを選択し、ゲームを起動
-(void) onBtnOnSubLayerPressed:(id) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"start_game.m4a"]; 

    CCTransitionTurnOffTiles *transition;
    transition = [CCTransitionTurnOffTiles transitionWithDuration:1.0f scene:[MultiLayerScene sceneWithGameModeTag:GameModeTagNormalGame]];
    [[CCDirector sharedDirector] replaceScene:transition];
}

////////////////////////////////////////////////////////////////////////////////
// 
-(void) onLink0:(id) sender
{
    [self appLink:0];
}
-(void) onLink1:(id) sender
{
    [self appLink:1];
}
-(void) onLink2:(id) sender
{
    [self appLink:2];
}
-(void) onLink3:(id) sender
{
    [self appLink:3];
}

-(void) onLink4:(id) sender
{
    [self appLink:4];
}

// ランキング表示
-(void) onLink5:(id) sender
{
    [self showBoard];
}

static NSString *sUrlString[] = 
{
    @"http://itunes.apple.com/jp/app/eroisukauta/id522610853?mt=8",
    @"http://itunes.apple.com/jp/app//id492248909?mt=8",
    @"http://itunes.apple.com/jp/app/id493524538?mt=8",
    @"http://itunes.apple.com/jp/app//id483367124?mt=8",
    @"http://www.b-a-r.jp/apps/",
};
-(void)appLink:(int)iId
{
    NSURL *url= [NSURL URLWithString:sUrlString[iId]];
    [[UIApplication sharedApplication] openURL:url];
}

// リーダーボードを表示する
- (void) showBoard
{
    
//    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate]; 
//    [delegate gameCenterLeaderboard];
}



@end
