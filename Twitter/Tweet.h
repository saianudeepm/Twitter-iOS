//
//  Tweet.h
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/8/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;

- (id) initWithDictionary: (NSDictionary *) dictionary;
+ (NSArray *)tweetsWithArray:(NSArray *)array;



@end
