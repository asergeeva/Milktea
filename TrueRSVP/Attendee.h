//
//  Attendee.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/27/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attendee : NSObject
{
	NSString *uid;
	NSString *fname;
	NSString *lname;
	NSString *email;
	BOOL isAttending;
}
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *fname;
@property (nonatomic, retain) NSString *lname;
@property (nonatomic, retain) NSString *email;
@property (nonatomic) BOOL isAttending;
@end
