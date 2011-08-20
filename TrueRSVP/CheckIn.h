//
//  CheckIn.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/20/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckIn : NSObject <NSCoding>
{
	NSString *eid;
	NSString *uid;
	BOOL isAttending;
	NSDate *date;
}
@property (nonatomic, retain) NSString *eid;
@property (nonatomic, retain) NSString *uid;
@property (nonatomic) BOOL isAttending;
@property (nonatomic, retain) NSDate *date;
@end
