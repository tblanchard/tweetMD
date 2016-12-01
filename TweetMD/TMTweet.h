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

// Task 2 - cache fetched images in memory
@property (nonatomic, strong) UIImage* image;

// Task 5 - need to store the star state on the model
@property (nonatomic, assign, getter=isStarred) BOOL starred;

@end
