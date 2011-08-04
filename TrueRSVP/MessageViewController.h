//
//  MessageViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/2/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
@interface MessageViewController : UIViewController <UITextViewDelegate>
{
	NSMutableArray *selectedFromList;
	IBOutlet UIView *eventWhiteBack;
	IBOutlet UILabel *eventName;
	IBOutlet UILabel *eventDate;
	IBOutlet UIView *toWhiteBack;
	IBOutlet UILabel *toLabel;
	IBOutlet UIButton *selectionButton;
	IBOutlet UIView *messageWhiteBack;
	IBOutlet UILabel *messageLabel;
	IBOutlet UITextView *messageTextView;
	IBOutlet UIButton *emailCheck;
	IBOutlet UIButton *textCheck;
	IBOutlet UILabel *sendAsEmail;
	IBOutlet UILabel *sendAsText;
	IBOutlet UIView *sendWhiteBack;
	IBOutlet UIButton *sendButton;
	Event *_event;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil list:(NSMutableArray*)list  event:(Event*)thisEvent;
- (IBAction)emailPressed:(UIButton*)sender;
- (IBAction)textPressed:(UIButton*)sender;
- (IBAction)sendPressed:(UIButton*)sender;
@property (nonatomic, copy) NSMutableArray *selectedFromList;
@property (nonatomic, retain) Event *_event;
@property (nonatomic, retain) IBOutlet UILabel *eventName;
@property (nonatomic, retain) IBOutlet UILabel *eventDate;
//@property (nonatomic, retain) IBOutlet UIButton *emailCheck;
//@property (nonatomic, retain) IBOutlet UIButton *textCheck;
//@property (nonatomic, retain) IBOutlet UIButton *sendButton;
@end
