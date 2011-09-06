//
//  QRViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 9/6/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRViewController : UIViewController
{
	NSString *_contents;
	IBOutlet UIImageView *qrView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil string:(NSString*)contents;
@end
