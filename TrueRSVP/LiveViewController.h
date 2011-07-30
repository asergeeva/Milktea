//
//  LiveViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/29/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MGTwitterEngine.h"
@interface LiveViewController : UIViewController //<MGTwitterEngineDelegate> 
{
	UIView *liveEventBack;
	IBOutlet UILabel *eventName;
	IBOutlet UILabel *eventDate;
	IBOutlet UIButton *cameraButton;
	IBOutlet UITextField *tweetField;
	IBOutlet UIButton *shareButton;
//	MGTwitterEngine *twit;
}

@property (nonatomic, retain) IBOutlet UIView *liveEventBack;
//@property (nonatomic, retain) IBOutlet MGTwitterEngine *twit;
@end
