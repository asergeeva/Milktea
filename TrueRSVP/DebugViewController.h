//
//  DebugViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/27/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
	
@interface DebugViewController : UIViewController <UITextFieldDelegate>
{
	IBOutlet UITextField *debugAddress;
	IBOutlet UIButton *debugDoneButton;
}
- (IBAction)dismissDebug:(id)sender;
@property (nonatomic, retain) IBOutlet UITextField *debugAddress;
@property (nonatomic, retain) IBOutlet UIButton *debugDoneButton;
@end
