//
//  TMUserMention.h
//  TweetMD
//
//  Created by Doximity on 1/14/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import <TwitterKit/TwitterKit.h>

@interface TMUserMention : NSObject

@property (nonatomic, readonly) NSString *userID;
@property (nonatomic, readonly) NSString *userScreenName;
@property (nonatomic, readonly) NSString *userFullName;
@property (nonatomic, readonly) NSNumber *startIndex; // this is the first number in the indices array
@property (nonatomic, readonly) NSNumber *endIndex; // this is the second number in the indices array

+ (NSArray*)userMentionsWithJSONArray:(NSArray *)userMentionJSONArray;
- (BOOL)isValidUserMention;
- (NSInteger)length;
- (NSRange)range;

@end
