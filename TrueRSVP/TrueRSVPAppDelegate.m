//
//  TrueRSVPAppDelegate.m
//  TrueRSVP
//
//  Created by movingincircles on 7/16/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "TrueRSVPAppDelegate.h"
#import "TrueRSVPViewController.h"
#import "SignInViewController.h"
#import "LiveViewController.h"
//#import "Reachability.h"
#import "QueuedActions.h"
#import "NetworkManager.h"
@implementation TrueRSVPAppDelegate
@synthesize window=_window;
@synthesize viewController=_viewController;
@synthesize facebook;
@synthesize navController;
BOOL didEnterBackground = NO;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	facebook = [[Facebook alloc] initWithAppId:@"122732554481304"];

	// Override point for customization after application launch.
	SignInViewController *signVC = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:[NSBundle mainBundle]];
	navController = [[UINavigationController alloc] initWithRootViewController:signVC];	
	self.window.rootViewController = navController;
//	[navController pushViewController:signVC animated:NO];
	[signVC release];

//	[self.window addSubview:navController.view];
	[self.window makeKeyAndVisible];
	
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	
	if([[url absoluteString] hasPrefix:@"fb"])
	{
		[facebook handleOpenURL:url];
	}
	else if ([[url absoluteString] hasPrefix:@"trueRSVP://handleOAuthLogin"])
	{
		NSArray *urlComponents = [[url absoluteString] componentsSeparatedByString:@"?"];
		NSArray *requestParameterChunks = [[urlComponents objectAtIndex:1] componentsSeparatedByString:@"&"];
		for (NSString *chunk in requestParameterChunks) 
		{
			NSArray *keyVal = [chunk componentsSeparatedByString:@"="];
		
			if ([[keyVal objectAtIndex:0] isEqualToString:@"oauth_verifier"]) 
			{
				for(UIViewController *vc in navController.viewControllers)
				{
					if([vc isKindOfClass:[LiveViewController class]])
					{
						[(LiveViewController*)vc handleOAuthVerifier:[keyVal objectAtIndex:1]];
					}
				}
			} 
		}
	}
	return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
	didEnterBackground = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
	if([[NetworkManager sharedNetworkManager] isSessionAlive])
	{
		if([[NetworkManager sharedNetworkManager] isOnline])
		{
			[[NetworkManager sharedNetworkManager] processQueue];
		}
	}
	else
	{
		if(didEnterBackground)
		{
			[navController popToRootViewControllerAnimated:YES];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signed out" message:@"You have beened signed out. Please log in again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			didEnterBackground = NO;
		}
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void)dealloc
{
	[facebook release];
	[_window release];
	[_viewController release];
	[navController release];
    [super dealloc];
}

@end
