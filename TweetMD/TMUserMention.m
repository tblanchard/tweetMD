//
//  TMUserMention.m
//  TweetMD
//
//  Created by Doximity on 1/14/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import "TMUserMention.h"

@interface TMUserMention ()
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userScreenName;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSNumber *startIndex;
@property (nonatomic, strong) NSNumber *endIndex;
@end

@implementation TMUserMention

#pragma mark - serialization

+ (NSArray*)userMentionsWithJSONArray:(NSArray *)userMentionJSONArray {
    // *** [TASK 4] ********
    // ** Implement this to serialize an array of TMUserMention objects
    // **
    // ** Input- array of JSON-formatted user mentions
    // ** Output - array of user mention objects
    // **
    // ** Completing this task should enable the highlight of @mentions in the tweet body text
    // **
    // ** Documentation: https://dev.twitter.com/overview/api/entities-in-twitter-objects
    // *********************
    
    return nil;
}

#pragma mark - validity helpers

- (BOOL)isValidUserMention {
    return [self hasValidIndices] && self.userID;
}

- (BOOL)hasValidIndices {
    return [self.startIndex isKindOfClass:NSNumber.class] && [self.endIndex isKindOfClass:NSNumber.class];
}

#pragma mark - range helpers

- (NSInteger)length {
    return self.endIndex.integerValue - self.startIndex.integerValue;
}

- (NSRange)range {
    return NSMakeRange(self.startIndex.integerValue, self.length);
}

@end
