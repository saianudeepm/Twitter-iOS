//
//  Tweet.m
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/8/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"

@implementation Tweet

- (id) initWithDictionary: (NSDictionary *) dictionary {
    self= [super init ];
    
    if(self){
        NSLog(@"Raw Tweet:\n : %@",dictionary);
        self.text = dictionary[@"text"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        self.idStr = dictionary[@"id_str"];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.retweetId = dictionary[@"retweeted_status.id"];
        
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

-(void) toggleRetweetStatus {
    
    //if the current state of the tweet is retweeted, unretweet it
    //NSDictionary *params = [[NSDictionary alloc] init];
    //[params setValue:self.retweetId forKey:@"retweet_id"];
    [[TwitterClient sharedInstance] retweetWithParams:nil tweet:self
     
                                           completion:^(Tweet *tweet, NSError *error) {
                                               [self setTweet:tweet];
                                               [self.delegate tweet:tweet didChangeRetweeted:YES];
                                           }];

}

-(void) setTweet:(Tweet* )tweet{

    self.text=tweet.text;
    self.retweetCount=tweet.retweetCount;
    self.retweeted = tweet.retweeted;
    self.favorited= tweet.favorited;
    self.favoriteCount = tweet.favoriteCount;
}

-(void)toggleFavoriteStatus{
    //if not favorited before, favorite it now
}

@end
