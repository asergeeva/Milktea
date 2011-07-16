//
//  TrueRSVPAppDelegate.h
//  TrueRSVP
//
//  Created by movingincircles on 7/16/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrueRSVPViewController;

@interface TrueRSVPAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TrueRSVPViewController *viewController;

@end
