//
//  TMTweetViewModel.h
//  TweetMD
//
//  Created by Doximity on 1/15/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TMTweet;

@interface TMTweetViewModel : NSObject

- (id)initWithTweet:(TMTweet *)tweet;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *handle;
@property (nonatomic, readonly) NSString *timeElapsed;
@property (nonatomic, readonly) NSAttributedString* attributedBodyText;
@property (nonatomic, readonly) NSString* profPicURL;

@end
