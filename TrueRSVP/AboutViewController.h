//
//  AboutViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/30/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController {
	UIButton *OKButton;
}
- (IBAction)dismiss:(id)sender;
@property (nonatomic, retain) IBOutlet UIButton *OKButton;

@end
