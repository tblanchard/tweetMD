//
//  NSDate+TweetMD.m
//  TweetMD
//
//  Created by Doximity on 1/15/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import "NSDate+TweetMD.h"

const NSInteger SECONDS_IN_WEEK = 604800;
const NSInteger SECONDS_IN_DAY = 86400;
const NSInteger SECONDS_IN_HOUR = 3600;
const NSInteger SECONDS_IN_MINUTE = 60;
const NSInteger MILLISECONDS_IN_DAY = 86400000;

@implementation NSDate (TweetMD)

#pragma mark - date formatters

+ (NSDateFormatter *)localShortDateFormatter {
    static dispatch_once_t token = 0;
    static NSDateFormatter *formatter = nil;
    dispatch_once(&token, ^{
        formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"M/d/yy"];
    });
    return formatter;
}

-(NSInteger)daysFrom:(NSDate *)date calendar:(NSCalendar *)calendar {
    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:earliest toDate:latest options:0];
    return multiplier*components.day;
}

-(NSInteger)daysFrom:(NSDate *)date{
    return [self daysFrom:date calendar:[NSCalendar currentCalendar]];
}

-(double)hoursFrom:(NSDate *)date{
    return ([self timeIntervalSinceDate:date])/SECONDS_IN_HOUR;
}

-(double)minutesFrom:(NSDate *)date{
    return ([self timeIntervalSinceDate:date])/SECONDS_IN_MINUTE;
}

-(double)secondsFrom:(NSDate *)date{
    return [self timeIntervalSinceDate:date];
}

@end
