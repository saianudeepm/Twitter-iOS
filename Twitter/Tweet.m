//
//  Tweet.m
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/8/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id) initWithDictionary: (NSDictionary *) dictionary {
    self= [super init ];
    
    if(self){
        //NSLog(@"Raw Tweet:\n : %@",dictionary);
        self.text = dictionary[@"text"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        self.tweetId = dictionary[@"id"];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
    }
    return self;
}

+ (NSArray *) tweetsWithArray:(NSArray *)array {

    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    for (NSDictionary* dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end
