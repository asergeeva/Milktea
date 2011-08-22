//
//  ProgressView.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"

@interface ProgressView : UIViewController <NetworkManagerDelegate>  {
	UIProgressView *progressBar;
	NSMutableArray *hostingList;
	NSTimer *timer;
}
- (void)progressCheck;
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar;
@property (nonatomic, retain) NSMutableArray *hostingList;
@property (nonatomic, assign) NSTimer *timer;
@end
