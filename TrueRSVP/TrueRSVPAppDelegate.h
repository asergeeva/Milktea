//
//  TrueRSVPAppDelegate.h
//  TrueRSVP
//
//  Created by movingincircles on 7/16/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "Reachability.h"
//@class TrueRSVPViewController;

@interface TrueRSVPAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> {
	Facebook *facebook;
	UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *viewController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) UINavigationController *navController;
@end
