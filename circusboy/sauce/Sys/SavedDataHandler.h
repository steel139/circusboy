//
//  SavedSceneDataHandler.h
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/05/15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavedDataHandler : NSObject {
    NSUserDefaults *defaults;
}

+(SavedDataHandler *)sharedSetting;
-(id)init;

-(BOOL)getIsPlayMusic;
-(void)toggleIsPlayMusic;
-(int)getHiScoar;
-(void)setHiScoar:(int)iScore;

@end
