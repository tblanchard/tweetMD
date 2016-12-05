//
//  TMUserMention.m
//  TweetMD
//
//  Created by Doximity on 1/14/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import "TMUserMention.h"

@interface TMUserMention ()
@property (nonatomic, strong) NSDictionary* json;
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

        TMUserMention* mention = [[self alloc]initWithJSONDictionary:json];
        // no point adding invalid objects
        if([mention isValidUserMention]) {
            [mentions addObject:mention];
        }
    }
    
    return mentions;
}

-(instancetype)initWithJSONDictionary:(NSDictionary*)dictionary
{
    if(self = [super init])
    {
        self.json = dictionary;
    }
    return self;
}

#pragma mark - accessors

-(NSString*)userID
{
    return self.json[@"id_str"];
}

-(NSString*)userScreenName
{
    return self.json[@"screen_name"];
}

-(NSString*)userFullName
{
    return self.json[@"name"];
}

-(NSNumber*)startIndex
{
    NSArray* indices = self.json[@"indices"];
    if(indices.count)
    {
        return indices[0];
    }
    return nil;
}

-(NSNumber*)endIndex
{
    NSArray* indices = self.json[@"indices"];
    if(indices.count > 1)
    {
        return indices[1];
    }
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
