//
//  ComposeViewController.h
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/9/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"


@protocol ComposeViewControllerDelegate <NSObject>

@required
- (void) didPostTweet: (Tweet *) tweet;

@optional
-(void) didPostTweetSuccessfully;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) Tweet *tweetReply;

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end
