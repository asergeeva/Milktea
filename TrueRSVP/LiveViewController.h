//
//  LiveViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/29/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"
#import "UploadMedia.h"
#import "Event.h"
#import "ASIFormDataRequest.h"
@class OAuth, TwitterLoginPopup;
@interface LiveViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TwitterLoginPopupDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ASIHTTPRequestDelegate>
{
	UIView *liveEventBack;
	IBOutlet UILabel *eventName;
	IBOutlet UILabel *eventDate;
	IBOutlet UIButton *cameraButton;
	IBOutlet UITextField *tweetField;
	IBOutlet UIButton *shareButton;
	NSMutableArray *tweets;
	IBOutlet UITableView *tweetTable;
	UIBarButtonItem *logoutButton;
	Event *thisEvent;
//	NSMutableDictionary *lastTweet;
//	UIAlertView *showUploadingMessage;
//	UIImageView *uploadingMessage;
	TwitterLoginPopup *loginPopup;
	OAuth *oAuth;
//	MGTwitterEngine *twit;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)thisEvent;
- (void)updateStream;
- (IBAction)tweet:(UIButton*)sender;
- (void)handleOAuthVerifier:(NSString *)oauth_verifier;
- (void)login;
- (IBAction)cameraPressed:(id)sender;
- (void)logout;
@property (nonatomic, retain) IBOutlet UIView *liveEventBack;
@property (nonatomic, retain) IBOutlet UITableView *tweetTable;
@property (nonatomic, retain) Event *thisEvent;
@property (nonatomic, retain) NSMutableArray *tweets;
//@property (nonatomic, retain) NSMutableDictionary *lastTweet;
@property (nonatomic, retain) UIBarButtonItem *logoutButton;
//@property (nonatomic, retain) UIImageView *uploadingMessage;
//@property (nonatomic, retain) UIAlertView *showUploadingMessage;
//@property (nonatomic, retain) IBOutlet MGTwitterEngine *twit;
@end
