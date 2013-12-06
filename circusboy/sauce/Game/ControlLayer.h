//
//  ControlLayer.h
//  Kopipe-Chapter4
//
//  Created by Sho Tachibana on 11/09/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define Z_INDEX_PAUSE_LAYER 0
#define TAG_PAUSE_LAYER 100

@interface ControlLayer : CCLayer {
    CGPoint mTouchStartPoint;   // 初めにタッチした座標の保存
    CGPoint mTouchPoint;        // 初めにタッチした位置の座標をコンバートした座標
}

-(void)removeTouchDispatcher;

// タップされた点がポーズボタン上かどうかをチェックする
-(BOOL)getIsTapPause:(UITouch *)touch;

@end
