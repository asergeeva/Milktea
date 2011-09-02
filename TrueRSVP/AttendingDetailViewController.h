//
//  AttendingDetailViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/23/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ASIFormDataRequest.h"
#import "UITextViewUneditable.h"
#import "ZBarReaderViewController.h"
@interface AttendingDetailViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, ASIHTTPRequestDelegate, ZBarReaderDelegate>
{
	Event *eventAttending;
	IBOutlet UIView *eventWhiteBack;
	IBOutlet UILabel *eventName;
	IBOutlet UILabel *eventDate;
	IBOutlet UIView *eventDescriptionWhiteBack;
	IBOutlet UITextViewUneditable *eventDescription;
	IBOutlet UITextView *eventAddress;
	IBOutlet MKMapView *eventMap;
	IBOutlet UIButton *contact;
	IBOutlet UIButton *directions;
	IBOutlet UIButton *update;
	IBOutlet UIButton *checkIn;
	IBOutlet UIButton *live;
	IBOutlet UIView *buttonWhiteBack;

	NSString *organizerEmail;
//	NSURL *someURL;
	float lat;
	float lng;
//	NSMutableString *address;
	ZBarReaderViewController *reader;
//	UILabel *QRData;
}
- (void)dismissCamera;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)event;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (IBAction)showLive:(UIButton*)sender;
- (IBAction)showMail:(UIButton*)sender;
- (IBAction)showMap:(UIButton*)sender;
- (IBAction)showRSVP:(UIButton*)sender;
- (IBAction)checkIn:(UIButton*)sender;
- (void)mapRequestFinished:(ASIHTTPRequest *)request;
- (void)mapRequestFailed:(ASIHTTPRequest *)request;
@property (nonatomic, retain) Event *eventAttending;
@property (nonatomic, retain) IBOutlet UIView *eventWhiteBack;
@property (nonatomic, retain) IBOutlet UILabel *eventName;
@property (nonatomic, retain) IBOutlet UILabel *eventDate;
@property (nonatomic, retain) IBOutlet UIView *eventDescriptionWhiteBack;
@property (nonatomic, retain) IBOutlet UITextViewUneditable *eventDescription;
@property (nonatomic, retain) IBOutlet MKMapView *eventMap;
@property (nonatomic, retain) IBOutlet UIButton *contact;
@property (nonatomic, retain) IBOutlet UIButton *directions;
@property (nonatomic, retain) IBOutlet UIButton *update;
@property (nonatomic, retain) IBOutlet UIButton *checkIn;
@property (nonatomic, retain) IBOutlet UIButton *live;
@property (nonatomic, retain) IBOutlet UIView *buttonWhiteBack;;
@property (nonatomic, retain) NSString *organizerEmail;
//@property (nonatomic, retain) NSURL *someURL;
@property (nonatomic) float lat;
@property (nonatomic) float lng;
@property (nonatomic, retain) ZBarReaderViewController *reader;
//@property (nonatomic, retain) NSMutableString *address;
@end
