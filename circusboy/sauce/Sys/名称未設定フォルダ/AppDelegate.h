//
//  AppDelegate.h
//  Kopipe-Chapter3
//
//  Created by Sho Tachibana on 11/10/16.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapperController.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    
    TapperController    *mpTapperController;
}

@property (nonatomic, retain) UIWindow *window;

@end
