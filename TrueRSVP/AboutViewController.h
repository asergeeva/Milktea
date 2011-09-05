//
//  AboutViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/30/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UIWebViewDelegate> {
	UIButton *OKButton;
	IBOutlet UIWebView *webView;
	IBOutlet UIButton *legalButton;
	BOOL legalShown;
	IBOutlet UITextView *legalView;
}
- (IBAction)dismiss:(id)sender;
- (IBAction)legal:(id)sender;
@property (nonatomic, retain) IBOutlet UIButton *OKButton;

@end
