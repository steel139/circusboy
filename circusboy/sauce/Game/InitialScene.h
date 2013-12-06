//
//  InitialScene.h
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/05/11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// 画面上のオブジェクトを識別する為のタグ
typedef enum {
    ObjectTagSubLayer,
    ObjectTagBtnNormalGame,
    ObjectTagBtnTime500,
    ObjectTagBtnTime1000,
    ObjectTagBtnChop10,
    ObjectTagBtnChop30,
    ObjectTagBtnChop1
} ObjectTag;

@interface InitialScene : CCLayer {
    // 時間ラベル
    CCLabelTTF *timeLabel;
    
}

+(id) scene; 

//
-(void) onLink0:(id)  sender;
-(void) onLink1:(id)  sender;
-(void) onLink2:(id)  sender;
-(void) onLink3:(id)  sender;
-(void) appLink:(int) iId;


@end
