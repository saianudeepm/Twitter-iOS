//
//  DetailedViewController.m
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/9/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "DetailedViewController.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"


@interface DetailedViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;


@end

@implementation DetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    
    //populate all the items in the view
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[self.selectedTweet.user profileImageUrl]] placeholderImage:[UIImage imageNamed:@"icn_profile_placeholder"]];
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
    
    self.nameLabel.text = [self.selectedTweet.user name];
    self.screenNameLabel.text = [self.selectedTweet.user screename];
    self.tweetTextLabel.text = self.selectedTweet.text;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",self.selectedTweet.createdAt];
    self.retweetsLabel.text = [NSString stringWithFormat:@"%ld",self.selectedTweet.retweetCount];
    self.favoritesLabel.text =[NSString stringWithFormat:@"%ld",self.selectedTweet.favoriteCount];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma  mark - private methods

- (void) setupNavBar{
    
    // Style the Navigational Bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85.0 / 255.0 green:172.0 / 255.0 blue:238.0 / 255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = @"Tweet";
    
    self.navigationController.navigationBar.translucent = NO;
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        for (Tweet *tweet in tweets) {
            NSLog(@"text : %@", tweet.text);
        }
    }];
    
    //Add two buttons at the top right of Nav Bar
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icn_profile_search"] style:UIBarButtonItemStylePlain target:self action:@selector(onSearchClick)];
    searchButton.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *composeTweetButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn_profile_compose"] style:UIBarButtonItemStylePlain target:self action:@selector(onComposeClick)];
    composeTweetButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItems = @[composeTweetButton,searchButton];
   
    //set up the back button
    
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void) onSearchClick {
    // do something
}

-(void) onComposeClick {
    //launch the compose view controller
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

@end
