//
//  TMTweet.h
//  TweetMD
//
//  Created by Doximity on 1/14/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import <TwitterKit/TwitterKit.h>

@interface TMTweet : TWTRTweet

@property (nonatomic, strong) NSArray *userMentions;

@end
