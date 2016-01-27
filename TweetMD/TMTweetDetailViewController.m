//
//  TMTweetDetailViewController.m
//  TweetMD
//
//  Created by Doximity on 1/15/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import "TMTweetDetailViewController.h"
#import "TMTweet.h"
#import "TMTweetViewModel.h"

@interface TMTweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@end

@implementation TMTweetDetailViewController

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadTweet];
}

#pragma mark - loading data

- (void)loadTweet {
    if (!self.tweet) return;
    
    TMTweetViewModel *viewModel = [[TMTweetViewModel alloc] initWithTweet:self.tweet];
    
    self.nameLabel.text = viewModel.name;
    self.handleLabel.text = viewModel.handle;
    self.bodyLabel.attributedText = viewModel.attributedBodyText;

    [self loadImageFromURL:viewModel.profPicURL];
}

- (void)loadImageFromURL:(NSString*)imageURL {
    if (!imageURL) return;
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    self.profilePicImageView.image = image;
}

#pragma mark - ibactions

- (IBAction)tappedStarButton:(id)sender {
    // ** [TASK 5] ********
    // ** Implement the star/unstar functionality
    // **
    // ** When items are starred:
    // ** 1. The button should have background color [UIColor starredYellow]
    // ** 2. The button text should be "Starred!"
    // ** 3. The corresponding row on the home feed should have background color [UIColor starredYellow].
    // **
    // ** When items are not starred
    // ** 1. The button should have background color [UIColor actionBlue]
    // ** 2. The button text should be "Star this Tweet"
    // ** 3. The corresponding row on the home feed should have background color [UIColor whiteColor]
    // **
    // NOTE: Starred tweets do not need to persist across sessions. This means that when I kill / restart the app, my previous stars do not need to be saved.
    // *********************
}

@end
