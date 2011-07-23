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
- (id)init
{
	if((self = [super init]))
	{
		uid = [[NSMutableString alloc] init];
		fullName = [[NSMutableString alloc] init];
		email = [[NSMutableString alloc] init];
		cell = [[NSMutableString alloc] init];
		zip = [[NSMutableString alloc] init];
		twitter = [[NSMutableString alloc] init];
		about = [[NSMutableString alloc] init];
	}
	return self;
}
- (void)updateUser:(NSDictionary*)userInfo
{
//	[uid release];
//	uid = [[NSString alloc] initWithString:[userInfo objectForKey:@"id"]];
	[uid setString:[userInfo objectForKey:@"id"]];
//	[fullName release];
//	fullName = [[NSString alloc] initWithFormat:@"%@ %@", [userInfo objectForKey:@"fname"], [userInfo objectForKey:@"lname"]];
	[fullName setString:[NSString stringWithFormat:@"%@ %@", [userInfo objectForKey:@"fname"], [userInfo objectForKey:@"lname"]]];
	//	[email release];
//	email = [[NSString alloc] initWithString:[userInfo objectForKey:@"email"]];
	[email setString:[userInfo objectForKey:@"email"]];
//	[cell release];
//	cell = [[NSString alloc] initWithString:[userInfo objectForKey:@"phone"]];
	[cell setString:[userInfo objectForKey:@"phone"]];
//	[zip release];
//	zip = [[NSString alloc] initWithString:[userInfo objectForKey:@"zip"]];
	[zip setString:[userInfo objectForKey:@"zip"]];
//	[about release];
//	about = [[NSString alloc] initWithString:[userInfo objectForKey:@"about"]];
	[about setString:[userInfo objectForKey:@"about"]];
//	[twitter release];
//	twitter = [[NSString alloc] initWithString:[userInfo objectForKey:@"twitter"]];
	[twitter setString:[userInfo objectForKey:@"twitter"]];
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
	[about release];
	[super dealloc];
}
@end
