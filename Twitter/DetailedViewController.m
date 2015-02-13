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


@interface DetailedViewController () <TweetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
- (IBAction)onReply:(id)sender;
- (IBAction)onRetweet:(id)sender;
- (IBAction)onFavorite:(id)sender;

@end

@implementation DetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    [self setUpViews];
    // Do any additional setup after loading the view from its nib.
}

-(void) updateValues {
    self.retweetsLabel.text = [NSString stringWithFormat:@"%ld", (long)self.selectedTweet.retweetCount];
    self.favoritesLabel.text = [NSString stringWithFormat:@"%ld", (long)self.selectedTweet.favoriteCount];
    self.favoriteButton.selected = self.selectedTweet.favorited;
    self.retweetButton.selected = self.selectedTweet.retweeted;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TweetDelegate Methods

-(void) tweet: (Tweet *) tweet didChangeFavorited: (BOOL) favorited {
    [self updateValues];
}

-(void) tweet: (Tweet *) tweet didChangeRetweeted: (BOOL) retweeted {
    [self updateValues];

    NSLog(@"I see so twitter client actually succeeded in toggling the status of retweet nice :)");
    
}


#pragma  mark - private methods

- (void) setUpViews{

    //populate all the items in the view
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[self.selectedTweet.user profileImageUrl]] placeholderImage:[UIImage imageNamed:@"icn_profile_placeholder"]];
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
    
    self.nameLabel.text = [self.selectedTweet.user name];
    self.screenNameLabel.text = [self.selectedTweet.user screename];
    
    self.tweetTextLabel.text = self.selectedTweet.text;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",self.selectedTweet.createdAt];
    
    self.retweetsLabel.text = [NSString stringWithFormat:@"%ld",(long)self.selectedTweet.retweetCount];
    self.favoritesLabel.text =[NSString stringWithFormat:@"%ld",(long)self.selectedTweet.favoriteCount];
    
    [self.retweetButton setImage:[UIImage imageNamed:@"icn_retweet_off_large"] forState:UIControlStateNormal];
    [self.retweetButton setImage:[UIImage imageNamed:@"icn_retweet_on_large"] forState:UIControlStateSelected];
    
    [self.favoriteButton setImage:[UIImage imageNamed:@"icn_favorite_off_large"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"icn_favorite_on_large"] forState:UIControlStateSelected];
    
    [self updateValues];

}

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

#pragma mark - Button Actions
- (IBAction)onReply:(id)sender {
    [self onComposeClick];
}

- (IBAction)onRetweet:(id)sender {

    //if retweet is already selected then prompt the user and un retweet it
    if([self.retweetButton isSelected]){
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* undoRetweettAction = [UIAlertAction actionWithTitle:@"Undo Retweet" style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * action) {
                                                                 [self.retweetButton setSelected:NO];
                                                             }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
        [alert addAction:undoRetweettAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        //[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retweet", @"Quote Tweet", nil];
        //[alert show];
        
    }
        //if not already retweeted, prompt the user and un retweet it
    else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* tweettAction = [UIAlertAction actionWithTitle:@"Tweet" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self.retweetButton setSelected:YES];
                                                                  [self.selectedTweet toggleRetweetStatus];
                                                                  
                                                              }];
        UIAlertAction* quoteTweettAction = [UIAlertAction actionWithTitle:@"Quote Tweet" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [self.retweetButton setSelected:NO];
                                                                 [self.selectedTweet toggleRetweetStatus];
                                                             }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
        [alert addAction:tweettAction];
        [alert addAction:quoteTweettAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
         //[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retweet", @"Quote Tweet", nil];
         //[alert show];
        
        
    }
}


- (IBAction)onFavorite:(id)sender {
    if([self.favoriteButton isSelected]){
        [self.favoriteButton setSelected:NO];
    }
    else{
        [self.favoriteButton setSelected:YES];
    }
    
    
}
@end
