//
//  TMTweetTableViewCell.m
//  TweetMD
//
//  Created by Doximity on 1/14/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import "TMTweetTableViewCell.h"
#import "TMTweet.h"
#import "TMTweetViewModel.h"

@interface TMTweetTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@end

@implementation TMTweetTableViewCell

#pragma mark - getter / setter

- (void)setTweet:(TMTweet *)tweet {
    _tweet = tweet;
    
    // in the xib: make sure the labels stick to the left and truncate accordingly. first to truncate should be handle, then name. date should always show fully
    // make sure image reload here is faster
    
    TMTweetViewModel *viewModel = [[TMTweetViewModel alloc] initWithTweet:self.tweet];
    
    self.nameLabel.text = viewModel.name;
    self.handleLabel.text = viewModel.handle;
    self.timeLabel.text = viewModel.timeElapsed;
    self.bodyLabel.attributedText = viewModel.attributedBodyText;
    
    [self loadImageFromURL:viewModel.profPicURL];
}

#pragma mark - helpers

- (void)loadImageFromURL:(NSString*)imageURL {
    // ** [TASK 2] ***************
    // **
    // ** Update the image loading logic here to prevent lag when scrolling on the tweet feed
    // ***************************
    
    if (!imageURL) return;
    
    self.profilePicImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
}


@end
