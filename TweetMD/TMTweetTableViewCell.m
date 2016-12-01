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
// Task 2
#import "UIImageView+AFNetworking.h"

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
    
    // by 'faster' do we really mean 'faster' or less disruptive (no UI hangs but data might pop in late)?
    
    // As a result of second try - I added an image reference to the tweet object to cache it.
    // this can put us at risk of memory exhaustion so also implement didReceiveMemoryWarning in the
    // TMFeedViewController and nil the images on the tweets to get memory back
    
    // this is either an image or nil - nil is OK since we are removing stale image.
    self.profilePicImageView.image = self.tweet.image;
    
    if (!imageURL || self.tweet.image) return;
    
    // First try - tried using AFNetworking's async image loader
#if 0
    [self.profilePicImageView setImageWithURL: [NSURL URLWithString:imageURL]];
#endif
    // this made scrolling smoother but images definitely loaded more slowly than I would like - flashy.
    // so - smoother, but not really faster.  Slower actually.  Because AFNetwork will throttle the amount of work
    // to avoid overwhelming the connection and leave some bandwidth for other things.
    
    // But 'faster'. OK - Sometimes you gotta get your hands dirty to be fast. This feels faster to me:
    
    // In a perfect world all we need to do is:
    // self.profilePicImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    // but this synchronous call will suspend the UI while the image is fetched over what is probably
    // a crappy ATT or Sprint network and we know how they are. :-/
    // Instead we want to toss the network effort onto a background queue.
    // The rest of this method does that.
    
    // NOTE: If the comments seem excessive - its because I REALLY want this job and want to expose my thinking. :-)
    // I wouldn't leave nearly this level of verbosity in production code - just enough
    
    // First way we can get hosed....
    // cells get reused - need to guard against possibility that this cell
    // is no longer displaying the same tweet as when the URL has been loaded.
    // Lets remember our tweet and our self because self doesn't
    // automatically bind into blocks
    
    TMTweet* myTweet = self.tweet;
    TMTweetTableViewCell* me = self;
#if 1
    // toss the URL loading into the default queue which is lower priority than main queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // synchronous fetch which hangs the UI if performed on main thread
        // stash the fetched image on the tweet
        me.tweet.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        
        // now we have the image - but we can only fiddle the UI on the main thread or
        // VERY-BAD-THINGS-HAPPEN so...
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Remember how we remembered the tweet that goes with this image?
            // If myTweet isn't me.tweet then this cell has been reused and we
            // would set the wrong image which is a BAD USER EXPERIENCE.
            // In that case we bail.  If the tweet is redisplayed, we will get called again and
            // the image should be cached
            
            if(myTweet == me.tweet)
            {
                me.profilePicImageView.image = me.tweet.image;
            }
        });
    });
#endif
    
#if 0
    // This was try three to see if I could get more control with NSURLSession.  Results were disappointing.
    // playing with this on my 7 - it feels slower the AFNetworking category - images pop in slightly delayed
    // surprisingly - this is worst performer - even after increasing the memory cache size by a lot
    
    static NSURLSessionConfiguration *defaultConfiguration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSString *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *cachePath = [cachesDirectory stringByAppendingPathComponent:@"TweetCache"];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:134672*32 diskCapacity:268435456 diskPath:cachePath];
        defaultConfiguration.URLCache = cache;
        defaultConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        
    });
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    
    [[session dataTaskWithURL:[NSURL URLWithString:imageURL] completionHandler:^(NSData *data,
                                                                                 NSURLResponse *response,
                                                                                 NSError *error)
      {
          // still applies that my tweet may have been swapped out - so check
          if(!error && data)
          {
              me.tweet.image = [UIImage imageWithData:data];
              // set it on the main thread
              dispatch_async(dispatch_get_main_queue(), ^{
                  if(myTweet == me.tweet) { me.profilePicImageView.image = me.tweet.image; }
              });
          }
          
          if(error)
          {
              NSLog(@"Got response %@ with error %@.\n", response, error);
          }
          
      }] resume];
#endif
}


@end
