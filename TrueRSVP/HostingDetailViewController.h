//
//  HostingDetailViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface HostingDetailViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate>
{
	Event *eventHosting;
	IBOutlet UILabel *dynamicRSVP;
	IBOutlet UILabel *staticRSVP;
	IBOutlet UIView *yourRSVPBack;
	IBOutlet UIView *eventWhiteBack;
	IBOutlet UILabel *eventName;
	IBOutlet UILabel *eventDate;
	IBOutlet UIView *eventDescriptionWhiteBack;
	IBOutlet UITextView *eventDescription;
	IBOutlet MKMapView *eventMap;
	IBOutlet UIButton *contact;
	IBOutlet UIButton *checkIn;
	IBOutlet UIButton *live;
	IBOutlet UIView *buttonWhiteBack;
	
	float lat;
	float lng;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)event;
@property (nonatomic, retain) Event *eventHosting;
@property (nonatomic, retain) UILabel *dynamicRSVP;
@property (nonatomic, retain) UILabel *staticRSVP;
@property (nonatomic, retain) UIView *yourRSVPBack;
@property (nonatomic, retain) IBOutlet UIView *eventWhiteBack;
@property (nonatomic, retain) IBOutlet UILabel *eventName;
@property (nonatomic, retain) IBOutlet UILabel *eventDate;
@property (nonatomic, retain) IBOutlet UIView *eventDescriptionWhiteBack;
@property (nonatomic, retain) IBOutlet UITextView *eventDescription;
@property (nonatomic, retain) IBOutlet MKMapView *eventMap;
@property (nonatomic, retain) IBOutlet UIButton *contact;
@property (nonatomic, retain) IBOutlet UIButton *checkIn;
@property (nonatomic, retain) IBOutlet UIButton *live;
@property (nonatomic, retain) IBOutlet UIView *buttonWhiteBack;;
//@property (nonatomic, retain) NSString *organizerEmail;
@property (nonatomic) float lat;
@property (nonatomic) float lng;

@end
