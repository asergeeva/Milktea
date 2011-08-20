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
}

@property (nonatomic, retain) IBOutlet UIProgressView *progressBar;

@end
