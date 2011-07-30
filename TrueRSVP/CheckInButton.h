//
//  CheckInButton.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/29/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInButton : UIButton
{
	NSString *eid;
	NSString *uid;
}
@property (nonatomic, retain) NSString *eid;
@property (nonatomic, retain) NSString *uid;
@end

