//
//  User.m
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/8/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString *const UserDidLoginNotification = @"UserDidLoginNotification";
NSString *const UserDidLogoutNotification = @"UserDidLogoutNotification";
@interface User()

@property NSDictionary *dictionary;

@end

@implementation User


static User *_currentUser=nil;
NSString * const kCurrentUserKey = @"kCurrentUserKey";

- (id) initWithDictionary: (NSDictionary *) dictionary {
    self= [super init];
    if(self){
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screename = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
    }
    return self;
}


+ (void)setCurrentUser:(User *)user{
    _currentUser = user;
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    
    //manually flush out the changes to dis
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (User *) currentUser {
    if(_currentUser ==nil){
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if(data!=nil){
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void) logout{
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    //Sends out a notificaiotn that the user has logged out and who ever has registered to listen to the event will know it
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

@end
