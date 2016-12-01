//
//  TMFeedViewController.m
//  TweetMD
//
//  Created by Doximity on 1/14/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import "TMFeedViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "TMTweetTableViewCell.h"
#import "TMTweet.h"
#import "TMTweetDetailViewController.h"

@interface TMFeedViewController ()
@property (nonatomic, strong) NSMutableArray *medicalTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TMFeedViewController

#pragma mark - getter/setter

- (NSMutableArray*)medicalTweets {
    if (!_medicalTweets) {
        _medicalTweets = [NSMutableArray new];
    }
    
    return _medicalTweets;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TweetMD";
    
    [self setupTableView];
    [self fetchMedicineTweets];
    
}

#pragma mark - setup

- (void)setupTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSString *identifier = NSStringFromClass(TMTweetTableViewCell.class);
    [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifier];
    
    // Task 1 - Auto sizing of row heights
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
}

#pragma mark - requests

- (void)fetchMedicineTweets {
    // documentation - https://dev.twitter.com/rest/reference/get/search/tweets
    
    NSError *error = nil;
    NSString *medicineSearchURL = @"https://api.twitter.com/1.1/search/tweets.json?locale=en&q=medicine&result_type=mixed&count=30";
    NSURLRequest *req = [[[TWTRAPIClient alloc] init] URLRequestWithMethod:@"GET" URL:medicineSearchURL parameters:nil error:&error];
    
    [[[TWTRAPIClient alloc] init] sendTwitterRequest:req completion:^(NSURLResponse * response, NSData * data, NSError * connectionError) {
        if (error) {
            NSLog(@"Error fetching search results for medicine: %@", error.description);
        } else if (data) {
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (jsonError) {
                NSLog(@"There was an error serializing the JSON response for medicine search: %@", error.description);
            } else {
                NSArray *responseObjects = [json objectForKey:@"statuses"];
                [self.medicalTweets addObjectsFromArray:[TMTweet tweetsWithJSONArray:responseObjects]];
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.medicalTweets.count;
}

/* Task 1 - remove to allow auto sizing of rows
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
*/
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMTweet *tweet = [self.medicalTweets objectAtIndex:indexPath.row];
    
    TMTweetTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TMTweetTableViewCell.class)];
    cell.tweet = tweet;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TMTweet *tweet = [self.medicalTweets objectAtIndex:indexPath.row];
    
    TMTweetDetailViewController *detailVC = [TMTweetDetailViewController new];
    detailVC.tweet = tweet;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

// Task 2
- (void)didReceiveMemoryWarning
{
    for(TMTweet* tweet in self.medicalTweets) {
        tweet.image = nil;
    }
}

@end
