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


@interface DetailedViewController () <TweetDelegate,ComposeViewControllerDelegate>
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

-(void) setTweetView :(Tweet *) tweet ;
-(void) setTweetAndFavoriteCounts:(Tweet*) displayTweet tweet:(Tweet *)tweet;

@end

@implementation DetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    [self setUpViews];
    self.selectedTweet.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

-(void) updateValues {
    Tweet *displayTweet;
    Tweet *tweet = self.selectedTweet;
    //if retweeted tweet
    if(tweet.retweeted){
        displayTweet = tweet.retweetedTweet;
    }
    else{
        displayTweet= tweet;
    }
    [self setTweetAndFavoriteCounts: displayTweet tweet:tweet];
    
    /*
    self.retweetsLabel.text = [NSString stringWithFormat:@"%ld", (long)self.selectedTweet.retweetCount];
    self.favoritesLabel.text = [NSString stringWithFormat:@"%ld", (long)self.selectedTweet.favoriteCount];
    self.favoriteButton.selected = self.selectedTweet.favorited;
    self.retweetButton.selected = self.selectedTweet.retweeted;
    */

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TweetDelegate Methods

-(void) tweet: (Tweet *) tweet didChangeFavorited: (BOOL) favorited {
    //[self.selectedTweet setTweet:tweet];
    self.selectedTweet = tweet;
    [self updateValues];
}

-(void) tweet: (Tweet *) tweet didChangeRetweeted: (BOOL) retweeted {
    self.selectedTweet = tweet;
    [self updateValues];

    NSLog(@"I see so twitter client actually succeeded in toggling the status of retweet nice :)");
    
}


#pragma  mark - private methods

- (void) setUpViews{
    
    [self.retweetButton setImage:[UIImage imageNamed:@"icn_retweet_off_large"] forState:UIControlStateNormal];
    [self.retweetButton setImage:[UIImage imageNamed:@"icn_retweet_on_large"] forState:UIControlStateSelected];
    
    [self.favoriteButton setImage:[UIImage imageNamed:@"icn_favorite_off_large"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"icn_favorite_on_large"] forState:UIControlStateSelected];
    //populate all the items in the view
     [self setTweetView:self.selectedTweet];
    
}


- (void)setTweetView:(Tweet *)tweet {
    
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
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
    
    
    self.nameLabel.text = displayTweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", displayTweet.user.screename ];
    self.tweetTextLabel.text = displayTweet.text;
    
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
    [self setTweetAndFavoriteCounts: displayTweet tweet:tweet];
    
}

-(void) setTweetAndFavoriteCounts:(Tweet*) displayTweet tweet:(Tweet *)tweet{

    if(tweet.retweetCount > 0){
        self.retweetsLabel.text = [NSString stringWithFormat:@"%ld", (long)displayTweet.retweetCount];
    }else{
        self.retweetsLabel.text = @"";
    }
    
    if(displayTweet.favoriteCount >0){
        self.favoritesLabel.text = [NSString stringWithFormat:@"%ld", (long)displayTweet.favoriteCount];
    }else{
        self.favoritesLabel.text = @"";
    }
    
    if (tweet.retweeted) {
        self.retweetsLabel.textColor = [UIColor colorWithRed:122.0/255.0
                                                       green:177.0/255.0
                                                        blue:76.0/255.0
                                                       alpha:1.0];
        [self.retweetButton setSelected:YES];
        
    }else {
        self.retweetsLabel.textColor = [UIColor grayColor];
        [self.retweetButton setSelected:NO];
    }
    
    if(tweet.favorited){
        /*self.favoriteLabel.textColor = [UIColor colorWithRed:253.0/255.0
         green:173.0/255.0
         blue:22.0/255.0
         alpha:1.0];
         */
        [self.favoriteButton setSelected:YES];
        
    }else{
        self.favoritesLabel.textColor = [UIColor grayColor];
        [self.favoriteButton setSelected:NO];
    }


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
    cvc.delegate= self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

- (void) didPostTweet: (Tweet *) tweet{

    [self.delegate didReply:tweet];
}

#pragma mark - Button Actions
- (IBAction)onReply:(id)sender {
    [self onComposeClick];
}

- (IBAction)onRetweet:(id)sender {

    //if retweet is already selected then prompt the user and un retweet it
    if([self.retweetButton isSelected] ||  self.selectedTweet.retweeted){
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* undoRetweettAction = [UIAlertAction actionWithTitle:@"Undo Retweet" style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * action) {
                                                                 [self.retweetButton setSelected:NO];
                                                                 [self.selectedTweet toggleRetweetStatus];
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
    if(self.favoriteButton.selected){
        [self.selectedTweet toggleFavoriteStatus];
        [self.favoriteButton setSelected:NO];
    }
    else{
        [self.selectedTweet toggleFavoriteStatus];
        [self.favoriteButton setSelected:YES];

    }
    
    
}

@end
