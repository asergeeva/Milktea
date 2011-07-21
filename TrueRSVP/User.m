//
//  User.m
//  TrueRSVP
//
//  Created by movingincircles on 7/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//
#import "Constants.h"
#import "User.h"
#import "SynthesizeSingleton.h"

@implementation User
SYNTHESIZE_SINGLETON_FOR_CLASS(User);
@synthesize uid;
@synthesize fullName;
@synthesize email;
@synthesize cell;
@synthesize zip;
@synthesize twitter;
@synthesize profilePic;
@synthesize about;
@synthesize delegate;
- (void)updateUser:(NSDictionary*)userInfo
{
	uid = [userInfo objectForKey:@"id"];
	fullName = [NSString stringWithFormat:@"%@ %@", [userInfo objectForKey:@"fname"], [userInfo objectForKey:@"lname"]];
	email = [userInfo objectForKey:@"email"];
	cell = [userInfo objectForKey:@"phone"];
	zip = [userInfo objectForKey:@"zip"];
	about = [userInfo objectForKey:@"about"];
	//twitter = [userInfo objectForKey:@"twitter"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", rootAddress, @"upload/user/images/", uid, @".png"]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	request.delegate = self;
	[request startAsynchronous];
	[self.delegate updatedStrings];
}
- (void)requestFinished:(ASIHTTPRequest*)request
{
	profilePic = [[UIImage alloc] initWithData:[request responseData]];
	[self.delegate updatedImages];
}
- (void)requestFailed:(ASIHTTPRequest*)request
{
	
}
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
