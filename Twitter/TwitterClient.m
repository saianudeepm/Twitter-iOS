//
//  TwitterClient.m
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/8/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "Tweet.h"


//NSString * const kTwitterConsumerKey = @"MZhbSkepzr9iws6Sb1imQYNnU";
//NSString * const kTwitterConsumerSecret =@"x70h6OQNRfzK3GI0f2Ql55id11lDpVnYcUUqeCnONYVVowJTvi";

NSString *const kTwitterConsumerKey = @"98SHujYPX4rMdeuAe0LQGBZCj";
NSString * const kTwitterConsumerSecret =@"z3UQbv1ORsYgx6B13LuCrF9S3V7MBWbnCBZlEk3FKqu9ovHzEI";

NSString * const kTwitterBaseUrl = @"https://api.twitter.com";
NSString *const UserPostedNewTweet = @"UserPostedNewTweet";

@interface TwitterClient()
@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);
@end

@implementation TwitterClient

+ (TwitterClient*) sharedInstance{
    //static - will run only once
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;

    //Leverages Grand Central Dispatch -GCD .
    //Thread safe - performant than @synchronized
    dispatch_once(&onceToken, ^{
        if(instance == nil){
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void) loginWithCompletion : (void (^)(User * user, NSError * error)) completion{
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"twitterdemo://oauth"]
                              scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Fetched the Request token");
                                  
        //send the users to authorization url after getting the request token
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",requestToken.token]];
        
                                  [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the request token");
        self.loginCompletion(nil,error);
        
    }];
}


- (void) openURL:(NSURL *)url{

    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"Got the access Token");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //Set current user 
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];

            NSLog(@"current user: %@", user.name);
            // call completion whose reference is stored in self.loginCompletion with the respective values
            self.loginCompletion(user, nil);

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //Do something for failure
            self.loginCompletion(nil,error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the Access Token");
        self.loginCompletion(nil,error);
    }]
    ;
}

- (void) homeTimelineWithParams:(NSDictionary *)params completion:(void (^) (NSArray *tweets, NSError *error)) completion{

    [self GET:@"1.1/statuses/home_timeline.json?include_my_retweet=1" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];



}

- (void) mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^) (NSArray *tweets, NSError *error)) completion{
    
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];
    
    
    
}

- (void)postTweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion {
    // refer to https://dev.twitter.com/rest/reference/post/statuses/update
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
   
}

-(void) retweetWithParams:(NSDictionary *)params tweet:(Tweet*)tweet completion:(void(^)(Tweet *tweet, NSError *error))completion{
    
  
    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json",tweet.idStr] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completion(nil, error);
        NSLog(@"error is : %@", error);
    }];
}

-(void) unReTweetWithParams:(NSDictionary *) params tweet:(Tweet *) tweet completion:(void(^) (Tweet *tweet, NSError *error))completion{
    
     NSLog(@"un retweeting %@",tweet.idStr);
    [self POST:[NSString stringWithFormat:@"1.1/statuses/destroy/%@.json",tweet.retweetId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completion(nil, error);
        NSLog(@"error is : %@", error);
    }];
}


-(void) favoriteWithParams:(NSDictionary *) params tweet:(Tweet *) tweet completion:(void(^) (Tweet *tweet, NSError *error))completion{
    NSString *requestURL = [NSString stringWithFormat:@"1.1/favorites/create.json?id=%@",tweet.idStr];
    NSLog(@"favoriting the tweet %@, with request %@",tweet.idStr, requestURL);
    [self POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completion(nil, error);
        NSLog(@"error is : %@", error);
    }];
}

-(void) unfavoriteWithParams:(NSDictionary *) params tweet:(Tweet *) tweet completion:(void(^) (Tweet *tweet, NSError *error))completion{
    NSString *requestURL = [NSString stringWithFormat:@"1.1/favorites/destroy.json?id=%@",tweet.idStr];
    NSLog(@"Unfavoriting the tweet %@, with request %@",tweet.idStr, requestURL);
    [self POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completion(nil, error);
        NSLog(@"error is : %@", error);
    }];
}


@end
