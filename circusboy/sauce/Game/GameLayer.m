//
//  GameLayer.m
//  Kopipe-Chapter4
//
//  Created by Sho Tachibana on 11/09/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "MultiLayerScene.h"
#import "SavedDataHandler.h"

// ゲームセンター
#import "GameKit/GkScore.h"
#import "GameKit/GKLeaderboardViewController.h"

@implementation GameLayer


////////////////////////////////////////////////////////////////////////////////
// 初期化
-(id) init
{
    if ((self = [super init]))
    {
        // 画面サイズの取得
        CGSize winSize = [[CCDirector sharedDirector] winSize];

        ////////////////////////////////////////////////////////////////////////
        // ラベル系の初期化
        // テキストの色を赤に設定
        scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:25];
        scoreLabel.anchorPoint = CGPointMake(0.5f, 0.5f);
        // テキストの色を黄色に設定
        scoreLabel.color = ccc3(255, 255, 0);
        
        [scoreLabel setContentSize:CGSizeMake(200, scoreLabel.contentSize.height)];
        
        scoreLabel.position = ccp(winSize.width - scoreLabel.contentSize.width / 2 - 180, winSize.height - scoreLabel.contentSize.height / 2 - 15);

        
        [scoreLabel setString:@"0"];
        [self addChild:scoreLabel];
        
        
        
        ////////////////////////////////////////////////////////////////////////
        // JumpGame
        mpJump = [JumpGame alloc];
        [mpJump init:self];
        
    }

    // 関数updateの呼び出しを開始
    [self scheduleUpdate];

    return self;
}


////////////////////////////////////////////////////////////////////////////////
// updata
-(void) update:(ccTime)delta
{
    // 経過時間を追加
    totalTime += delta;

    // ジャンプのアップデート
    if([mpJump update:delta] == false)
    {
        // ゲームオーバー画面を呼び出す
        [self performSelector:@selector(showGameOver:)];
        return;
    }
    
    // スコア表示
    [scoreLabel setString:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%d", mpJump.mScore]]];

    
}


////////////////////////////////////////////////////////////////////////////////
// 画面タッチ時の操作
// (UIEvent *)eventは渡されるが使用していない。 
-(void)doTouchBoxWhisDir:(TOUCH_DIRECTION_TAG)iTouchDir TouchPoint:(CGPoint)iTouchPoint withEvent:(UIEvent *)event
{
    ////////////////////////////////////////////////////////////////////////////
    // ジャンプゲーム用
    [mpJump.mpJumpPlayer doTouch:iTouchDir TouchPoint:iTouchPoint withEvent:event];
    
}

// -----------------------------------------------------------------------------
// ボタンを離したときに呼び出される関数
-(void)doReleaseWhisDir:(TOUCH_DIRECTION_TAG)iTouchDir TouchPoint:(CGPoint)iTouchPoint withEvent:(UIEvent *)event
{

    ////////////////////////////////////////////////////////////////////////////
    // ジャンプゲーム用
    [mpJump.mpJumpPlayer doRelease:iTouchDir TouchPoint:iTouchPoint withEvent:event];
    
}




// -----------------------------------------------------------------------------
// ドラッグしたときに呼び出される関数
-(void)doTouchMovedWhisDir:(TOUCH_DIRECTION_TAG)iTouchDir TouchPoint:(CGPoint)iTouchPoint withEvent:(UIEvent *)event
{
}


////////////////////////////////////////////////////////////////////////////////
// ゲームオーバー画面の作成
////////////////////////////////////////////////////////////////////////////////
-(void)showGameOver:(id)sender
{
    [self unscheduleUpdate];
    [self unscheduleAllSelectors];
    [[[MultiLayerScene sharedLayer] controlLayer] removeTouchDispatcher];
    
    CCNode* node;
    CCARRAY_FOREACH([self children], node)
    {
        [node stopAllActions];
    }
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCLayerColor *subLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 180)];
    
    CCSprite *titleSprite = [CCSprite spriteWithFile:@"score_title.png"];
    titleSprite.position = ccp(winSize.width / 2, winSize.height / 2 + 40.0f);
    [subLayer addChild:titleSprite];
    titleSprite.opacity = 0;
    [self performSelector:@selector(fadeInObject:) withObject:titleSprite afterDelay:0.6f];

    
    // スコアの送信
    [self reportScore:mpJump.mScore forCategory:@"CircusBoy"];
    
    // ハイスコアの更新
    int aHiScoar = [[SavedDataHandler sharedSetting] getHiScoar];
    if(aHiScoar < mpJump.mScore){
        aHiScoar = mpJump.mScore;
        [[SavedDataHandler sharedSetting] setHiScoar:mpJump.mScore];
    }

    
    CCLabelTTF *resultLabel;
    resultLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", mpJump.mScore] fontName:@"Marker Felt" fontSize:50];

    resultLabel.position = ccp(winSize.width / 2, winSize.height / 2);
    [subLayer addChild:resultLabel];
    resultLabel.opacity = 0;
    [self performSelector:@selector(fadeInObject:) withObject:resultLabel afterDelay:0.9f];
    
    CCMenuItem *btn1 = [CCMenuItemImage itemFromNormalImage:@"score_retry.png" selectedImage:@"score_retry_p.png" target:self selector:@selector(onRetryPressed:)];
    btn1.position = ccp(-130, -80);
    CCMenuItemImage *btn2 = [CCMenuItemImage itemFromNormalImage:@"score_top.png" selectedImage:@"score_top_p.png" target:self selector:@selector(onGoToTopPressed:)];
    btn2.position = ccp(130, -80);
    CCMenu *menu = [CCMenu menuWithItems:btn1, btn2, nil];
    menu.contentSize = CGSizeMake(winSize.width, winSize.height);
    menu.position = ccp(winSize.width / 2, winSize.height / 2);
    [subLayer addChild:menu];
    isMenuReady = NO;
    [self performSelector:@selector(menuReady:) withObject:menu afterDelay:1.5f];
    
    [self addChild:subLayer z:50];
    isSubLayerExists = YES;
}


-(void)fadeInObject:(id)sender
{
    isMenuReady = NO;
    CCSprite *obj = (CCSprite *)sender;
    CCFadeTo *action = [CCFadeTo actionWithDuration:1.0f opacity:255];
    [obj runAction:action];
}

-(void)menuReady:(id)sender
{
    isMenuReady = YES;
}

// -----------------------------------------------------------------------------
// リトライ処理
-(void)onRetryPressed:(id)sender
{
    if(!isMenuReady) {
        return;
    }

    mpJump.IsStop = true;
    [[MultiLayerScene sharedLayer] showLoading];
}


// -----------------------------------------------------------------------------
// ランキング処理
-(void)onRankingPressed:(id)sender
{
    
}

// -----------------------------------------------------------------------------
// タイトルに移動
-(void)onGoToTopPressed:(id)sender
{
    if(!isMenuReady) {
        return;
    }
    mpJump.IsStop = true;
    [[MultiLayerScene sharedLayer] showInitialScene];
    
}


////////////////////////////////////////////////////////////////////////////////
// スコアの送信
- (void) reportScore:(int64_t)iScore forCategory:(NSString*) category
{ 
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = iScore;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            //報告エラーの処理
            CCLOG(@"ERROR MESSAGE");
        }else{
            NSLog(@"MAYBE OK");//console に"多分OK"を出力
        }
    }];
}


-(void)pauseGame
{
    [mpJump stopNewFire];
    [[CCDirector sharedDirector] pause];
}

-(void)resumeGame
{
    [mpJump setNewFire_];
    [[CCDirector sharedDirector] resume];
}


-(void)removeAndCleanUpObject:(id)sender
{
    [(CCSprite *)sender removeFromParentAndCleanup:YES];
}

@end