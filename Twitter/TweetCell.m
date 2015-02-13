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
    NSURL *profileImageUrl = [NSURL URLWithString:tweet.user.profileImageUrl];
    [self.profileImageView setImageWithURL:profileImageUrl  placeholderImage:[UIImage imageNamed:@"icn_profile_placeholder"]];
    self.nameLabel.text = tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screename ];
    self.tweetLabel.text = tweet.text;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",tweet.createdAt];
    self.retweetLabel.text = [NSString stringWithFormat:@"%ld", (long)tweet.retweetCount];
    self.favoriteLabel.text = [NSString stringWithFormat:@"%ld", (long)tweet.favoriteCount];
    
}


@end
