//
//  AttendingDetailViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/23/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventAttending.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface AttendingDetailViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate>
{
	EventAttending *eventAttending;
	IBOutlet UIView *eventWhiteBack;
	IBOutlet UILabel *eventName;
	IBOutlet UILabel *eventDate;
	IBOutlet UIView *eventDescriptionWhiteBack;
	IBOutlet UITextView *eventDescription;
	IBOutlet MKMapView *eventMap;
	IBOutlet UIButton *contact;
	IBOutlet UIButton *directions;
	IBOutlet UIButton *update;
	IBOutlet UIButton *checkIn;
	IBOutlet UIButton *live;
//	NSURL *someURL;
	float lat;
	float lng;
//	NSMutableString *address;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(EventAttending*)event;
- (IBAction)showMail:(id)sender;
- (IBAction)showMap:(id)sender;
- (IBAction)showRSVP:(id)sender;
@property (nonatomic, retain) EventAttending *eventAttending;
@property (nonatomic, retain) IBOutlet UIView *eventWhiteBack;
@property (nonatomic, retain) IBOutlet UILabel *eventName;
@property (nonatomic, retain) IBOutlet UILabel *eventDate;
@property (nonatomic, retain) IBOutlet UIView *eventDescriptionWhiteBack;
@property (nonatomic, retain) IBOutlet UITextView *eventDescription;
@property (nonatomic, retain) IBOutlet MKMapView *eventMap;
@property (nonatomic, retain) IBOutlet UIButton *contact;
@property (nonatomic, retain) IBOutlet UIButton *directions;
@property (nonatomic, retain) IBOutlet UIButton *update;
@property (nonatomic, retain) IBOutlet UIButton *checkIn;
@property (nonatomic, retain) IBOutlet UIButton *live;
//@property (nonatomic, retain) NSURL *someURL;
@property (nonatomic) float lat;
@property (nonatomic) float lng;
//@property (nonatomic, retain) NSMutableString *address;
@end
