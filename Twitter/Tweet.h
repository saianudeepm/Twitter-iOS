//
//  Tweet.h
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/8/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

//Forward declaration
@class Tweet;

@protocol TweetDelegate <NSObject>
-(void) tweet: (Tweet *) tweet didChangeFavorited: (BOOL) favorited;
-(void) tweet: (Tweet *) tweet didChangeRetweeted: (BOOL) retweeted;

@end

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, strong) NSString *retweetId;

- (id) initWithDictionary: (NSDictionary *) dictionary;
+ (NSArray *)tweetsWithArray:(NSArray *)array;

@property (nonatomic,weak) id<TweetDelegate> delegate;

-(void) setTweet:(Tweet* )tweet;
-(void) toggleRetweetStatus;

-(void) toggleFavoriteStatus;



@end
