//
//  TMTweetTableViewCell.h
//  TweetMD
//
//  Created by Doximity on 1/14/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>

@class TMTweet;

@interface TMTweetTableViewCell : UITableViewCell

@property (nonatomic, strong) TMTweet *tweet;

@end
