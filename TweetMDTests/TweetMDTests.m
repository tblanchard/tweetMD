//
//  TweetMDTests.m
//  TweetMDTests
//
//  Created by Doximity on 1/14/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMTweetViewModel.h"
#import "NSDate+TweetMD.h"

@interface TweetMDTests : XCTestCase

@end

@implementation TweetMDTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJustNow {
    
    TMTweetViewModel* model = [TMTweetViewModel new];
    
    // now is 'just now'
    NSString* relativeTime = [model timeElapsedStringSince:[NSDate date]];
    XCTAssertEqualObjects(relativeTime, @"just now");
    
    // 59 seconds ago is still 'just now'
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-59]];
    XCTAssertEqualObjects(relativeTime, @"just now");
    
    // this one should never happen - date is in future - still should turn up 'just now'
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:120]];
    XCTAssertEqualObjects(relativeTime, @"just now");
    
    // once we hit 60s, we start showing minutes - so make sure we don't do 'just now'
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-60]];
    XCTAssertNotEqualObjects(relativeTime, @"just now");
    
}

- (void)testMinutes {
    
    NSTimeInterval secondsPerMinute = 60;
    TMTweetViewModel* model = [TMTweetViewModel new];
    
    // 60s or more ago up until an hour we should get xm
    NSString* relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-secondsPerMinute]];
    XCTAssertEqualObjects(relativeTime, @"1m");
    
    // 1m + 1s = 1m
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerMinute+1)]];
    XCTAssertEqualObjects(relativeTime, @"1m");
    
    // 1m * 2 = 2m
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerMinute*2)]];
    XCTAssertEqualObjects(relativeTime, @"2m");
    
    // 1m * 59 = 59m
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerMinute*59)]];
    XCTAssertEqualObjects(relativeTime, @"59m");
    
    // (1m * 59 + 59s) = 59m
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerMinute*59+59)]];
    XCTAssertEqualObjects(relativeTime, @"59m");
    
    // make sure the rule doesn't hold anymore beyond here we start using hours
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerMinute*60)]];
    XCTAssertNotEqualObjects(relativeTime, @"60m");
    
}

- (void)testHours {
    
    NSTimeInterval secondsPerHour = 60*60;
    TMTweetViewModel* model = [TMTweetViewModel new];
    
    // 60m or more ago up until a day we should get xh
    NSString* relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-secondsPerHour]];
    XCTAssertEqualObjects(relativeTime, @"1h");
    
    // 1h + 1s = 1h
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerHour+1)]];
    XCTAssertEqualObjects(relativeTime, @"1h");
    
    // 1h * 2 = 2h
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerHour*2)]];
    XCTAssertEqualObjects(relativeTime, @"2h");
    
    // 1h * 23 = 23h
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerHour*23)]];
    XCTAssertEqualObjects(relativeTime, @"23h");
    
    // check upper bound - no more hours - we are on to days
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerHour*24)]];
    XCTAssertNotEqualObjects(relativeTime, @"24h");
    
}

- (void)testDays
{
    NSTimeInterval secondsPerDay = 60*60*24;
    TMTweetViewModel* model = [TMTweetViewModel new];
    
    // 24h or more ago up until a day we should get xd
    NSString* relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-secondsPerDay]];
    XCTAssertEqualObjects(relativeTime, @"1d");
    
    // 1d + 1s = 1d
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerDay+1)]];
    XCTAssertEqualObjects(relativeTime, @"1d");
    
    // 1d * 2 = 2d
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerDay*2)]];
    XCTAssertEqualObjects(relativeTime, @"2d");
    
    // 1h * 23 = 23h
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerDay*7)]];
    XCTAssertEqualObjects(relativeTime, @"7d");
    
    // Sorry Ringo
    relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerDay*7+1)]];
    XCTAssertNotEqualObjects(relativeTime, @"8d");
}

- (void)testMoreThanAWeek
{
    NSTimeInterval secondsPerDay = 60*60*24;
    TMTweetViewModel* model = [TMTweetViewModel new];
    
    // 7 days is the most
    NSString* relativeTime = [model timeElapsedStringSince:[NSDate dateWithTimeIntervalSinceNow:-(secondsPerDay*7)]];
    XCTAssertEqualObjects(relativeTime, @"7d");
    
    // and now we start showing the date as localShortDate
    NSDate* aWeekAndASecondAgo = [NSDate dateWithTimeIntervalSinceNow:-(secondsPerDay*8)];
    relativeTime = [model timeElapsedStringSince:aWeekAndASecondAgo];
    XCTAssertEqualObjects(relativeTime, [[NSDate localShortDateFormatter] stringFromDate:aWeekAndASecondAgo]);
}


@end
