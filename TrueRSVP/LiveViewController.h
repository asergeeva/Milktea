//
//  LiveViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/29/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "Event.h"
@interface LiveViewController : UIViewController <SA_OAuthTwitterControllerDelegate, SA_OAuthTwitterEngineDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
	UIView *liveEventBack;
	IBOutlet UILabel *eventName;
	IBOutlet UILabel *eventDate;
	IBOutlet UIButton *cameraButton;
	IBOutlet UITextField *tweetField;
	IBOutlet UIButton *shareButton;
	NSMutableArray *tweets;
	IBOutlet UITableView *tweetTable;
	UIBarButtonItem *logout;
	SA_OAuthTwitterEngine *twit;
	Event *event;
	NSMutableDictionary *lastTweet;
//	MGTwitterEngine *twit;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)thisEvent;
- (void)updateStream;
- (IBAction)tweet:(UIButton*)sender;
@property (nonatomic, retain) IBOutlet UIView *liveEventBack;
@property (nonatomic, retain) IBOutlet UITableView *tweetTable;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSMutableArray *tweets;
@property (nonatomic, retain) NSMutableDictionary *lastTweet;
@property (nonatomic, retain) UIBarButtonItem *logout;
//@property (nonatomic, retain) IBOutlet MGTwitterEngine *twit;
@end
