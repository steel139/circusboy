//
//  LoadingScene.m
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/05/15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoadingScene.h"
#import "MultiLayerScene.h"


@implementation LoadingScene

static GameModeTag sGameModeTag;

+(id) scene
{
    CCScene* scene = [CCScene node];
    LoadingScene* layer = [LoadingScene node];
    [scene addChild:layer];
    return scene;
}

+(id) sceneWithGameModeTag:(GameModeTag)gameModeTag
{
    sGameModeTag = gameModeTag;
    CCScene* scene = [CCScene node];
    LoadingScene* layer = [LoadingScene node];
    [scene addChild:layer];
    return scene;
}

-(id) init
{
    if ((self = [super init]))
    {
        [self setColor:ccc3(255, 255, 255)];
    }
    return self;
}

-(void)onEnterTransitionDidFinish
{
    [self performSelector:@selector(loadScene:) withObject:self afterDelay:1];
}

-(void)loadScene:(id)sender
{
    CCTransitionFadeUp *transition = [CCTransitionFadeUp transitionWithDuration:1.0f
                                                                          scene:[MultiLayerScene sceneWithGameModeTag:sGameModeTag]];
    [[CCDirector sharedDirector] replaceScene:transition];
}



@end
