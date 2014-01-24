//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)text {
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSString *)username {
    return [self.data valueOrNilForKeyPath:@"user.name"];
}

- (NSString *)screenName {
    return [NSString stringWithFormat:@"@%@", [self.data valueOrNilForKeyPath:@"user.screen_name"]];
}

- (NSURL *)profileImageURL {
    return [NSURL URLWithString:[self.data valueOrNilForKeyPath:@"user.profile_image_url"]];
}

- (NSString *)tweetDate {
    NSString *createdAt = [self.data valueOrNilForKeyPath:@"created_at"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM d HH:mm:ss Z yyyy"];
    NSDate *date = [dateFormat dateFromString:createdAt];
    NSTimeInterval interval = -[date timeIntervalSinceNow];
    
    int minutes = interval / 60;
    if (minutes < 60) {
        return [NSString stringWithFormat:@"%dm", minutes];
    }
    int hours = minutes / 60;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%dh", hours];
    }
    int days = hours / 24;
    if (days < 7) {
        return [NSString stringWithFormat:@"%dd", days];
    }
    
    NSDateFormatter *dateFormatOut = [[NSDateFormatter alloc] init];
    [dateFormatOut setDateFormat:@"MM/dd/yy"];
    return [dateFormatOut stringFromDate:date];
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
