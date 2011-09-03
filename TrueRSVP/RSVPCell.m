//
//  RSVPCell.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 9/3/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "RSVPCell.h"

@implementation RSVPCell
@synthesize confidence;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//		confidence = [[NSMutableString alloc] init];
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc
{
//	[confidence release];
	[super dealloc];
}
@end
