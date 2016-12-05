//
//  TMTweetViewModel.m
//  TweetMD
//
//  Created by Doximity on 1/15/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import "TMTweetViewModel.h"
#import "TMTweet.h"
#import "TMUserMention.h"
#import "UIColor+TweetMD.h"
#import "NSDate+TweetMD.h"

@interface TMTweetViewModel ()
@property (nonatomic, strong) TMTweet *tweet;
@end

@implementation TMTweetViewModel

#pragma mark - init

- (id)initWithTweet:(TMTweet *)tweet {
    self = [super init];
    if (self) {
        _tweet = tweet;
    }
    return self;
}

#pragma mark - view model helpers

- (NSString*)name {
    return self.tweet.author.name;
}

- (NSString*)handle {
    return self.tweet.author.formattedScreenName;
}

- (NSString*)timeElapsed {
    return [self timeElapsedStringSince:self.tweet.createdAt];
}

- (NSAttributedString*)attributedBodyText {
    return [self formattedBodyTextForTweet:self.tweet];
}

- (NSString*)profPicURL {
    return self.tweet.author.profileImageLargeURL;
}

- (UIColor*)backgroundColor
{
    return self.tweet.isStarred ? [UIColor starredYellow] : [UIColor whiteColor];
}

- (UIColor*)starButtonColor
{
    return self.tweet.isStarred ? [UIColor starredYellow] : [UIColor actionBlue];
}

- (NSString*)starButtonText
{
    return self.tweet.isStarred ? @"Starred!" : @"Star this Tweet";
}

#pragma mark - date helper

- (NSString*)timeElapsedStringSince:(NSDate*)date {
    // successful refactoring confirmed by tests
    return [date timeElapsedStringSinceNow];
}

#pragma mark - body link helper

- (NSAttributedString*)formattedBodyTextForTweet:(TMTweet*)tweet {
    if (!self.tweet.text) return nil;
    
    NSMutableAttributedString *tweetBodyAttrString = [[NSMutableAttributedString alloc] initWithString:tweet.text];

    for (TMUserMention *mention in tweet.userMentions) {
        if (mention.isValidUserMention) {
            [tweetBodyAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor actionBlue] range:mention.range];
        }
    }
    
    return tweetBodyAttrString;
}

@end
