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

- (NSString*)timeElapsedStringSinceNow {
    // ** [TASK 3] ********
    // ** There is a bug with this method! Please find it and fix it
    // **
    // ** Input- date to calculate elapsed time from
    // ** Output- time elapsed string:
    // **
    // ** 'just now' if less than 1 min ago
    // ** 1-59m for less than 1 hour ago
    // ** 1-23h for less than 1 day ago
    // ** 1-7d for less than 8 days ago
    // ** else, format the date e.g., 1/2/16
    // *********************
    
    NSDate *now = [NSDate date];
    NSInteger secondsFromNow = [now secondsFrom:self];
    NSInteger minutesFromNow = [now minutesFrom:self];
    NSInteger hoursFromNow = [now hoursFrom:self];
    NSInteger daysFromNow = [now daysFrom:self];
    
    if (secondsFromNow < 60) {
        return @"just now";
    } else if (minutesFromNow < 60) {
        return [NSString stringWithFormat:@"%@m", @(minutesFromNow)];
    } else if (hoursFromNow < 24) {
        return [NSString stringWithFormat:@"%@h", @(hoursFromNow)];
    } else if (daysFromNow <= 7) {
        return [NSString stringWithFormat:@"%@d", @(daysFromNow)];
    } else {
        return [[NSDate localShortDateFormatter] stringFromDate:self];
    }
}

@end
