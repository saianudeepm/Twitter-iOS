//
//  ProfileCellTableViewCell.m
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/16/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "ProfileCell.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"


@interface ProfileCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *switchSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *userDetailsLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end


@implementation ProfileCell

- (void)awakeFromNib {
    //disable the user selection on the cell
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setUser:(User *) user{
    [self.profileView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",user.screename];
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%ld",user.tweetCount];
    self.followCountLabel.text = [NSString stringWithFormat:@"%ld",user.followCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%ld",user.followersCount];
    //By default set the user tagline label to invisible
    self.userDetailsLabel.text = user.tagline;
    [self.userDetailsLabel setHidden:YES];
    //if there is no tag line then dont show the page control
    // hide page control if no tagline
    if (!user.tagline || [user.tagline isEqualToString:@""]) {
        [self.pageControl setHidden:YES];
    }
    else {
        [self.pageControl setHidden:NO];
    }
    NSString *bannerUrl = user.bannerUrl ? [NSString stringWithFormat:@"%@/mobile_retina", user.bannerUrl] :user.backgroundImageUrl ;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:bannerUrl]];

    //[self.headerImageView setBackgroundColor:[UIColor colorWithRed:85.0 / 255.0 green:172.0 / 255.0 blue:238.0 / 255.0 alpha:1]];
    //[self.headerImageView setTintColor:[UIColor colorWithRed:85.0 / 255.0 green:172.0 / 255.0 blue:238.0 / 255.0 alpha:1]];
    
}

- (IBAction)onPageContorlChanged:(UIPageControl *)sender {
    if(sender.currentPage ==0){
        [self.userDetailsLabel setHidden:YES];
        [self.followersCountLabel setHidden:NO];
        [self.followCountLabel setHidden:NO];
        [self.followersLabel setHidden:NO];
        [self.followingLabel setHidden:NO];
        [self.tweetCountLabel setHidden:NO];
        [self.tweetsLabel setHidden:NO];
        CGRect frame=   self.userDetailsLabel.frame;
        frame.origin.y=self.userDetailsLabel.frame.origin.y +30;
        self.userDetailsLabel.frame=frame;
    }
    else {
        [self.userDetailsLabel setHidden:NO];
        [self.followersCountLabel setHidden:YES];
        [self.followCountLabel setHidden:YES];
        [self.followersLabel setHidden:YES];
        [self.followingLabel setHidden:YES];
        [self.tweetCountLabel setHidden:YES];
        [self.tweetsLabel setHidden:YES];
        CGRect frame=   self.userDetailsLabel.frame;
        frame.origin.y=self.userDetailsLabel.frame.origin.y -30;
        self.userDetailsLabel.frame=frame;

        
    }
}


@end
