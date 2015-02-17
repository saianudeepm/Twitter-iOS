//
//  TweetCell.m
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/9/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
    //self.profileImageView.layer.cornerRadius = 3;
    //self.profileImageView.clipsToBounds = YES;
    //self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


// when this method is called , it sets the values of it self with the tweet data.
- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    Tweet *displayTweet;
    
    //if retweeted tweet
    if(tweet.retweeted){
        displayTweet = tweet.retweetedTweet;
    }
    else{
        displayTweet= tweet;
    }
    NSURL *profileImageUrl = [NSURL URLWithString:displayTweet.user.profileImageUrl];
    [self.profileImageView setImageWithURL:profileImageUrl  placeholderImage:[UIImage imageNamed:@"icn_profile_placeholder"]];
    self.nameLabel.text = displayTweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", displayTweet.user.screename ];
    self.tweetLabel.text = displayTweet.text;
    
    NSString *relativeTimeText;
    
    // show relative time
    NSTimeInterval timeIntervalInSeconds = -[displayTweet.createdAt timeIntervalSinceNow];
    
    //show in seconds
    if(timeIntervalInSeconds <60) {
        relativeTimeText = [NSString stringWithFormat:@"%.0fs",timeIntervalInSeconds];
    }
    //show in minutes
    else if(timeIntervalInSeconds < 3600){
         relativeTimeText = [NSString stringWithFormat:@"%.0fm",timeIntervalInSeconds/60];
    }
    //show in hours
    else if(timeIntervalInSeconds <86400){
        relativeTimeText = [NSString stringWithFormat:@"%.0fh",timeIntervalInSeconds/3600];
    }
    // show month day, year
    else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM d, yyyy"];
        relativeTimeText = [dateFormat stringFromDate:displayTweet.createdAt];
    }
    
    self.timeLabel.text = relativeTimeText;
    
    
    if(tweet.retweetCount > 0){
        self.retweetLabel.text = [NSString stringWithFormat:@"%ld", (long)displayTweet.retweetCount];
    }else{
        self.retweetLabel.text = @"";
    }
    
    if(displayTweet.favoriteCount >0){
        self.favoriteLabel.text = [NSString stringWithFormat:@"%ld", (long)displayTweet.favoriteCount];
    }else{
        self.favoriteLabel.text = @"";
    }

    if (tweet.retweeted) {
        self.retweetLabel.textColor = [UIColor colorWithRed:122.0/255.0
                                                      green:177.0/255.0
                                                       blue:76.0/255.0
                                                      alpha:1.0];
        [self.retweetImageView setImage:[UIImage imageNamed:@"icn_activity_retweet_on"]];
        
    }else {
        self.retweetLabel.textColor = [UIColor grayColor];
        [self.retweetImageView setImage:[UIImage imageNamed:@"icn_activity_retweet_off"]];
    }
    
    if(tweet.favorited){
        /*self.favoriteLabel.textColor = [UIColor colorWithRed:253.0/255.0
                                                       green:173.0/255.0
                                                        blue:22.0/255.0
                                                       alpha:1.0];
         */
        [self.favoriteImageView setImage:[UIImage imageNamed:@"icn_activity_favorite_on"]];
    }else{
        self.favoriteLabel.textColor = [UIColor grayColor];
        [self.favoriteImageView setImage:[UIImage imageNamed:@"icn_activity_favorite_off"]];
    }
    
}


@end
