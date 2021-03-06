//
//  AppDelegate.m
//  Kopipe-Chapter3
//
//  Created by Sho Tachibana on 11/10/16.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "InitialScene.h"
#import "imobileAds/IMAdView.h"

#import "RootViewController.h"

// ゲームセンター
#import "GameKit/GkScore.h"
#import "GameKit/GKLeaderboardViewController.h"
#import "TapperController.h"


@implementation AppDelegate

@synthesize window;



int64_t intLabelPoint=100;//LeaderBoardに送信するスコアです
NSString* LBID = @"jp.b-a-r.iPhone.circusboy";//iTunesConnectで設定したLeaderBoardのIDをセットします

- (void) reportScore: (int64_t) score forCategory: (NSString*) category
{ 
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            //報告エラーの処理
            NSLog(@"ERROR MESSAGE");
        }
        NSLog(@"MAYBE OK");//console に"多分OK"を出力
        [mpTapperController showLeaderboard];
    }];
}

//スコア送信ボタンが押されたら、ゲームセンターへスコアを送信します
- (void) sendScore{
    [self reportScore:intLabelPoint forCategory:LBID];
}

-(void)setScore 
{
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setTitle:@"スコア送信" forState:UIControlStateNormal];
    [sendButton sizeToFit];
    CGPoint newPoint2 = window.center;
    newPoint2.y +=80;
    sendButton.center = newPoint2;
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    [sendButton addTarget:self
                   action:@selector(sendScore)
         forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:sendButton];
}

////////////////////////////////////////////////////////////////////////////////
// 広告表示
#define YOUR_PUBLISHER_ID 12080
#define YOUR_MEDIA_ID 32302
#define YOUR_SPOT_ID 59718
- (void)addAdvertisement {
#if 0
    // 縦向き表示
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGRect frame = CGRectMake(0.0, winSize.height-kIMAdViewDefaultHeight, kIMAdViewDefaultWidth, kIMAdViewDefaultHeight);
#else
    // 横向き表示(画面左に配置)
    CGRect frame = CGRectMake(0.0f, 0.0f, kIMAdViewDefaultWidth, kIMAdViewDefaultHeight);
#endif

    IMAdView *imAdView = [[IMAdView alloc] initWithFrame:frame
                                             publisherId:YOUR_PUBLISHER_ID
                                                 mediaId:YOUR_MEDIA_ID
                                                  spotId:YOUR_SPOT_ID
                                                testMode:NO];
    
    // i-mobileの広告を表示するビューを、このビューに追加する。 
    [window addSubview:imAdView];
    // このビューに追加した為、imAdViewを解放する。 
    [imAdView release];     
    
    [self setScore];
}


- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];

    // タップコントローラーを取得する
    mpTapperController = [TapperController alloc];
    // 広告を挿入する
    [self addAdvertisement];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
//    [[CCDirector sharedDirector] runWithScene: [MultiLayerScene scene]];
    [[CCDirector sharedDirector] runWithScene: [InitialScene scene]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end
