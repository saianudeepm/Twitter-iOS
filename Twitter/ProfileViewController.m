//
//  ProfileViewController.m
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/16/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCell.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "DetailedViewController.h"
#import "ComposeViewController.h"

NSString* pTableCell = @"TweetCell";

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate,ProfileCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ProfileCell *dummyCell;
@property (nonatomic, strong) TweetCell *protoTypeCell;

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;

@property (nonatomic, strong) NSArray *tweets;

@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85.0 / 255.0 green:172.0 / 255.0 blue:238.0 / 255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = @"Profile";
    
    //set the data source and delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //register the cell nib
    UINib *profileCell = [UINib nibWithNibName:@"ProfileCell" bundle:nil];
    [self.tableView registerNib:profileCell forCellReuseIdentifier:@"ProfileCell"];

    User *user = self.user ? self.user : [User currentUser];
    
    //setup the background image. user bannerurl if not backfill with the background image
    NSString *bannerUrl = user.bannerUrl ? [NSString stringWithFormat:@"%@/mobile_retina", user.bannerUrl] :user.backgroundImageUrl ;
    [self.bannerImageView setImageWithURL:[NSURL URLWithString:bannerUrl]];
    // Do any additional setup after loading the view from its nib.
    
    //set up the tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:pTableCell bundle:nil] forCellReuseIdentifier:pTableCell];
    
    //set up the refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self fetchTweets];
    
    //Register to listen to the user posting a tweet notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPostNewTweet:) name:UserPostedNewTweet object:nil];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0)
        return 1;
    else
        return self.tweets.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileCell *profileCell = nil;
    TweetCell *tweetCell = nil;
    if(indexPath.section==0){
        profileCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        User *user;
        if(self.user){
            user = self.user;
        }
        else{
            user= [User currentUser];
        }
        [profileCell setUser:user];
        profileCell.delegate = self;
        return profileCell;
    
    }
    
    else{
        tweetCell = [self.tableView dequeueReusableCellWithIdentifier:pTableCell];
        tweetCell.tweet = self.tweets[indexPath.row];
        return tweetCell;
    }
    
    return nil;
}

#pragma mark - tableview delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section ==0){
        //set selection disabled
    }
    else {
        if(self.tweets!=nil){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            Tweet *selectedTweet = [self.tweets objectAtIndex:indexPath.row];
            DetailedViewController *dvc = [[DetailedViewController alloc] init];
            [dvc setSelectedTweet: selectedTweet];
            //UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:dvc];
            [self.navigationController pushViewController:dvc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        [self configureCell:self.dummyCell forRowAtIndexPath:indexPath];
        [self.dummyCell layoutIfNeeded];
        
        CGSize size = [self.dummyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        //return size.height+1;
        return 260;
    }
    else {
        [self configureCell:self.protoTypeCell forRowAtIndexPath:indexPath];
        [self.protoTypeCell layoutIfNeeded];
        CGSize size = [self.protoTypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    
    }
   
}

- (ProfileCell *)dummyCell {
    
    if (!_dummyCell) {
        _dummyCell = [self.tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    }
    return _dummyCell;
    
}

- (TweetCell *)protoTypeCell {
    
    if (!_protoTypeCell) {
        _protoTypeCell = [self.tableView dequeueReusableCellWithIdentifier:pTableCell];
    }
    return _protoTypeCell;
    
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){
        if ([cell isKindOfClass:[ProfileCell class]])
        {
            ProfileCell *profileCell = (ProfileCell *)cell;
            //textCell.business = self.businessListingArray[indexPath.row];
        }
    }
    else{
        if ([cell isKindOfClass:[TweetCell class]])
        {
            TweetCell *tweetCell = (TweetCell *)cell;
            tweetCell.tweet = self.tweets[indexPath.row];
        }
    }
    
}

#pragma  mark - profile cell delegate implementation
-(void) pageChanged:(UIPageControl *) pageControl{
    if(pageControl.currentPage==0){
        // do something
    }
}

# pragma mark - private methods

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

@end
