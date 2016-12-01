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
    
    
    // Task 4
    NSMutableArray* mentions = [NSMutableArray arrayWithCapacity:userMentionJSONArray.count];
    
    for (NSDictionary* json in userMentionJSONArray) {
        TMUserMention* mention = [self new];
        
        mention.userID = json[@"id_str"];
        mention.userScreenName = json[@"screen_name"];
        mention.userFullName = json[@"name"];
        NSArray* indices = json[@"indices"];
        
        // errors occur if you use an invalid index with NSArray
        if(indices && indices.count >= 2) {
            mention.startIndex = indices[0];
            mention.endIndex = indices[1];
        }
        // no point adding invalid objects
        if([mention isValidUserMention]) {
            [mentions addObject:mention];
        }
    }
    
    return mentions;
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
