//
//  TwitterClient.h
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/8/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

extern NSString *const UserPostedNewTweet;

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient*) sharedInstance;
- (void) loginWithCompletion : (void (^)(User * user, NSError * error)) completion;
- (void) openURL: (NSURL*) url;
- (void) homeTimelineWithParams:(NSDictionary *)params completion:(void (^) (NSArray *tweets, NSError *error)) completion;
- (void) mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^) (NSArray *tweets, NSError *error)) completion;
- (void)postTweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)retweetWithParams:(NSDictionary *)params tweet:(Tweet*)tweet completion:(void(^)(Tweet *tweet, NSError *error))completion;
-(void) unReTweetWithParams:(NSDictionary *) params tweet:(Tweet *) tweet completion:(void(^) (Tweet *tweet, NSError *error))completion;
-(void) favoriteWithParams:(NSDictionary *) params tweet:(Tweet *) tweet completion:(void(^) (Tweet *tweet, NSError *error))completion;
-(void) unfavoriteWithParams:(NSDictionary *) params tweet:(Tweet *) tweet completion:(void(^) (Tweet *tweet, NSError *error)) completion;
@end
