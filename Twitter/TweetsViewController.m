//
//  TweetsViewController.m
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/9/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "DetailedViewController.h"
#import "ComposeViewController.h"

NSString* tableCell = @"TweetCell";

@interface TweetsViewController ()  <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TweetCell *protoTypeCell;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (void) setupNavBar;


@end



@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setup Navigational Bar
    [self setupNavBar];
    
    //set up the tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:tableCell bundle:nil] forCellReuseIdentifier:tableCell];
    
    //set up the refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self fetchTweets];
    
    //Register to listen to the user posting a tweet notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPostNewTweet:) name:UserPostedNewTweet object:nil];
    
    
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


#pragma mark - tableview datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:tableCell];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - tableview delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(self.tweets!=nil){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        Tweet *selectedTweet = [self.tweets objectAtIndex:indexPath.row];
        DetailedViewController *dvc = [[DetailedViewController alloc] init];
        [dvc setSelectedTweet: selectedTweet];
        //UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:dvc];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self configureCell:self.protoTypeCell forRowAtIndexPath:indexPath];
    [self.protoTypeCell layoutIfNeeded];
    CGSize size = [self.protoTypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
    //return 110;
}

- (TweetCell *)protoTypeCell {
    
    if (!_protoTypeCell) {
        _protoTypeCell = [self.tableView dequeueReusableCellWithIdentifier:tableCell];
    }
    return _protoTypeCell;
    
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[TweetCell class]])
    {
        TweetCell *tweetCell = (TweetCell *)cell;
        tweetCell.tweet = self.tweets[indexPath.row];
    }
}

#pragma mark - private methods

- (void) setupNavBar{
    
    // Style the Navigational Bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85.0 / 255.0 green:172.0 / 255.0 blue:238.0 / 255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = @"Home";
    
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
    
    // Add logout button at the top left of the Nav Bar
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    
    self.navigationItem.leftBarButtonItem = logoutButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
}

-(void) onSearchClick {
    
}

-(void) onComposeClick {
    //launch the compose view controller
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

-(void) onLogout{
    [User logout];
    
}


-(void) fetchTweets{

    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        if(!error){
            self.tweets = tweets;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
        else {
            [self.refreshControl endRefreshing];
            UILabel *errorLabel = [[UILabel alloc]init];
            errorLabel.text = @"Network Error";
            [self.tableView insertSubview:errorLabel atIndex:0];
            NSLog(@"Error getting the tweets : %@", error);
        }
    }];
}

-(void) onRefresh {
    //refetch the tweets
    [self fetchTweets];

}

- (void)onPostNewTweet :(NSNotification *) notification {
    NSDictionary *userInfo = notification.userInfo;
    Tweet *newTweet = userInfo[@"tweet"];
    NSMutableArray *allTweets = [NSMutableArray arrayWithObject:newTweet];
    [allTweets addObjectsFromArray:self.tweets];
    self.tweets = allTweets;
}

@end
