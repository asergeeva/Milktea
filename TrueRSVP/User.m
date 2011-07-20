//
//  User.m
//  TrueRSVP
//
//  Created by movingincircles on 7/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "User.h"
#import "SynthesizeSingleton.h"

@implementation User
SYNTHESIZE_SINGLETON_FOR_CLASS(User);
@synthesize fullName;
@synthesize email;
@synthesize cell;
@synthesize zip;
@synthesize twitter;
@synthesize profilePic;
- (void)dealloc
{
	[fullName release];
	[email release];
	[cell release];
	[zip release];
	[twitter release];
	[profilePic release];
	[super dealloc];
}
@end
