//
//  SettingScene.h
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/05/15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SettingScene : CCLayer {
    CCMenuItem *musicOn;
    CCMenuItem *musicOff;
}

+(id) scene;

@end
