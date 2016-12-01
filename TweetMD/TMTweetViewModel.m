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

#pragma mark - date helper

- (NSString*)timeElapsedStringSince:(NSDate*)date {
    // ** [TASK 3] ********
    // ** There is a bug with this method! Please find it and fix it
    // **
    // ** Input- date to calculate elapsed time from
    // ** Output- time elapsed string:
    // **
    // ** 'just now' if less than 1 min ago
    // ** 1-59m for less than 1 hour ago
    // ** 1-23h for less than 1 day ago
    // ** 1-7d for less than 8 days ago
    // ** else, format the date e.g., 1/2/16
    // *********************
    
    if (!date) return nil;
    
    NSDate *now = [NSDate date];
    NSInteger secondsFromNow = [now secondsFrom:date];
    NSInteger minutesFromNow = [now minutesFrom:date];
    NSInteger hoursFromNow = [now hoursFrom:date];
    NSInteger daysFromNow = [now daysFrom:date];
    
    if (secondsFromNow < 60) {
        return @"just now";
    } else if (minutesFromNow < 60) {
        return [NSString stringWithFormat:@"%@m", @(minutesFromNow)];
    } else if (hoursFromNow < 24) {
        return [NSString stringWithFormat:@"%@h", @(hoursFromNow)];
    } else if (daysFromNow <= 7) {
        return [NSString stringWithFormat:@"%@d", @(daysFromNow)];
    } else {
        return [[NSDate localShortDateFormatter] stringFromDate:date];
    }
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
