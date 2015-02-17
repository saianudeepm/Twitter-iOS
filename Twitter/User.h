//
//  User.h
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/8/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screename;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, assign) NSInteger tweetCount;
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, strong) NSString *bannerUrl;
@property (nonatomic, strong) NSString *backgroundImageUrl;

- (id) initWithDictionary: (NSDictionary *) dictionary;
+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
+ (void)logout;

@end
