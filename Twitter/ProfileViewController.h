//
//  ProfileViewController.h
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/16/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) User *user; // this user object is used to populate the user profile view

@end
