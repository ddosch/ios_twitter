//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *screenName;
@property (nonatomic, strong, readonly) NSString *tweetDate;
@property (nonatomic, strong, readonly) NSString *tweetDateFull;
@property (nonatomic, strong, readonly) NSString *retweets;
@property (nonatomic, strong, readonly) NSString *favorites;
@property (nonatomic, strong, readonly) NSURL *profileImageURL;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
