//
//  SavedSceneDataHandler.m
//  CharaCube
//
//  Created by 国吉 真木朗 on 12/05/15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SavedDataHandler.h"


@implementation SavedDataHandler

static SavedDataHandler *sharedSettingManager;

+(SavedDataHandler *)sharedSetting
{
    @synchronized(self) {
        if (sharedSettingManager == nil) {
            sharedSettingManager = [[self alloc] init];
        }
    }
    return sharedSettingManager;
}

-(id)init
{
    defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"isPlayMusic", nil];
    [defaults registerDefaults:dic];
    dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0], @"KEY_HI_SCORE", nil];
//    [defaults setObject:@"0" forKey:@"KEY_HI_SCORE"];
    [defaults registerDefaults:dic];
    return self;
}

-(int)getHiScoar
{
    return [defaults integerForKey:@"KEY_HI_SCORE"];
}
-(void)setHiScoar:(int)iScore
{
    [defaults setInteger:iScore forKey:@"KEY_HI_SCORE"];

}


-(BOOL)getIsPlayMusic
{
    return [defaults boolForKey:@"isPlayMusic"];
}

-(void)toggleIsPlayMusic
{
    BOOL b = [defaults boolForKey:@"isPlayMusic"];
    if(b)
    {
        [defaults setBool:NO forKey:@"isPlayMusic"];
    }
    else 
    {
        [defaults setBool:YES forKey:@"isPlayMusic"];
    }
    [defaults synchronize];
}




@end
