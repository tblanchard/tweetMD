//
//  TMTweet.m
//  TweetMD
//
//  Created by Doximity on 1/14/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import "TMTweet.h"
#import "TMUserMention.h"

@interface TMTweet ()
@property (nonatomic, strong) NSDictionary *jsonDict;
@end

@implementation TMTweet

#pragma mark - overrides

+ (NSArray*)tweetsWithJSONArray:(NSArray *)tweetJSONArray {
    NSMutableArray *tweetsArray = [NSMutableArray arrayWithCapacity:tweetJSONArray.count];
    
    for (NSDictionary* tweetJSON in tweetJSONArray) {
        TMTweet *tweet = [[TMTweet alloc] initWithJSONDictionary:tweetJSON];
        [tweetsArray addObject:tweet];
    }
    
    return tweetsArray;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary {
    self = [super initWithJSONDictionary:dictionary];
    if (self) {
        self.jsonDict = dictionary;
    }
    
    return self;
}

#pragma mark - user mention helpers

- (NSArray*)userMentions {
    NSDictionary *entities = [self.jsonDict objectForKey:@"entities"];
    NSArray *urlsJSON = [entities objectForKey:@"user_mentions"];
    return [TMUserMention userMentionsWithJSONArray:urlsJSON];
}

@end
