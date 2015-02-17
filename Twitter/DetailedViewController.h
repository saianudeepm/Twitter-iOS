//
//  DetailedViewController.h
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/9/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol DetailedViewControllerDelegate <NSObject>

- (void)didRetweet :(BOOL)didRetweet;
- (void)didFavorite:(BOOL)didFavorite;
- (void)didReply: (Tweet *) tweet;

@end

@interface DetailedViewController : UIViewController

@property (nonatomic, weak) id<DetailedViewControllerDelegate> delegate;
@property (nonatomic,strong) Tweet* selectedTweet;

@end
