//
//  MainViewController.h
//  TrueRSVP
//
//  Created by movingincircles on 7/18/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController {
//	IBOutlet UINavigationBar *navBar;
	UIView *profileView;
	UIView *attendingView;
	UIView *hostingView;
	UIView *segmentButtons;
	UIButton *profileButton;
	UIButton *attendingButton;
	UIButton *hostingButton;
}
//@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) UIView *profileView;
@property (nonatomic, retain) UIView *attendingView;
@property (nonatomic, retain) UIView *hostingView;
@property (nonatomic, retain) UIView *segmentButtons;
@property (nonatomic, retain) UIButton *profileButton;
@property (nonatomic, retain) UIButton *attendingButton;
@property (nonatomic, retain) UIButton *hostingButton;

@end
