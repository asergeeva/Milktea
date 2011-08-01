//
//  UITextViewUneditable.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/31/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "UITextViewUneditable.h"

@implementation UITextViewUneditable

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (BOOL)canBecomeFirstResponder {
    return NO;
}
@end
