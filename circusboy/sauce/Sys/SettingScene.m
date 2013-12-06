//
//  SettingScene.m
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/05/15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingScene.h"
#import "SavedDataHandler.h"
#import "InitialScene.h"

@implementation SettingScene

+(id) scene
{
    CCScene* scene = [CCScene node];
    SettingScene* layer = [SettingScene node];
    [scene addChild:layer];
    return scene;
}

-(id) init
{
    if ((self = [super init]))
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"setting_bg.png"];
        
        bg.position = ccp(winSize.width /2, winSize.height / 2);
        [self addChild:bg];
        
        CCSprite *titleSprite = [CCSprite spriteWithFile:@"setting_sound.png"];
        titleSprite.position = ccp(winSize.width / 2 - 60.0f, winSize.height / 2 + 23.0f);
        [self addChild:titleSprite];
        
        
        musicOn = [CCMenuItemImage itemFromNormalImage:@"setting_on.png" selectedImage:@"setting_on.png" target:nil selector:nil];
        musicOff = [CCMenuItemImage itemFromNormalImage:@"setting_off.png" selectedImage:@"setting_off.png" target:nil selector:nil];
        CCMenuItemToggle *btnToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(onToggleMusic:) items:musicOn, musicOff, nil];
        
        if([[SavedDataHandler sharedSetting] getIsPlayMusic])
        {
            btnToggle.selectedIndex = 0;
        }
        else 
        {
            btnToggle.selectedIndex = 1;
        }
        btnToggle.position = ccp(50, 22);
        
        CCMenuItem *btn2 = [CCMenuItemImage itemFromNormalImage:@"sub_back.png" selectedImage:@"sub_back_p.png" target:self selector:@selector(onBackPressed:)];
        btn2.position = ccp(-winSize.width / 2 + btn2.contentSize.width / 2 + 20.0f, winSize.height / 2 - btn2.contentSize.height / 2 - 20.0f);
        CCMenu *menu = [CCMenu menuWithItems:btnToggle, btn2, nil];
        menu.contentSize = CGSizeMake(winSize.width, winSize.height);
        menu.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:menu];
    }
    return self;
}

-(void)onToggleMusic:(id)sender
{
    [[SavedDataHandler sharedSetting] toggleIsPlayMusic];
}


-(void)onBackPressed:(id)sender
{
    CCTransitionTurnOffTiles *transition = [CCTransitionTurnOffTiles transitionWithDuration:1.0f scene:[InitialScene scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
    
}

@end
