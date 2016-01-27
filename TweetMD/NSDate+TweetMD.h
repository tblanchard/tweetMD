//
//  NSDate+TweetMD.h
//  TweetMD
//
//  Created by Doximity on 1/15/16.
//  Copyright © 2016 Doximity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TweetMD)

+ (NSDateFormatter *)localShortDateFormatter;

-(NSInteger)daysFrom:(NSDate *)date;
-(double)hoursFrom:(NSDate *)date;
-(double)minutesFrom:(NSDate *)date;
-(double)secondsFrom:(NSDate *)date;

@end
