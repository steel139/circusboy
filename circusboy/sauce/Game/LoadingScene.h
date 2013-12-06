//
//  LoadingScene.h
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/05/15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MultiLayerScene.h"


@interface LoadingScene : CCLayerColor {
    
}

+(id) scene;
+(id) sceneWithGameModeTag:(GameModeTag)gameModeTag;


@end
