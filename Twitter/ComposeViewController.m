//
//  ComposeViewController.m
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/9/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ComposeViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *tweetTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) UIBarButtonItem *textCounter;
@property (nonatomic, strong) UIBarButtonItem *tweetButton;

@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

- (void) setupNavBar;
@end

@implementation ComposeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //setup the nav bar
    [self setupNavBar];
    
    //set up the user name and profile pic
    self.nameLabel.text = [[User currentUser] name];
    self.screenNameLabel.text = [[User currentUser]screename];
    [self.profileImageView  setImageWithURL:[NSURL URLWithString:[[User currentUser] profileImageUrl]]];
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
    
    // make the text field the first responder
    self.tweetTextField.enabled =YES;
    [self.tweetTextField becomeFirstResponder];
    
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
#pragma  mark - TextField Deletegate



#pragma mark - private methods

- (IBAction)onTweetTextChange:(id)sender {
    NSInteger countRemaining = 140 - [self.tweetTextField.text length];
    if(countRemaining<0)
    {
        [self.tweetButton setEnabled:NO];
    }
    else if(countRemaining>=0) {
        [self.tweetButton setEnabled:YES];
    }
    
    self.textCounter.title = [NSString stringWithFormat:@"%ld", (long)countRemaining];
}



-(void) setupNavBar {

    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn_pointer_dismiss"] style:UIBarButtonItemStylePlain target:self action:@selector(onDismiss)];
    
    self.textCounter = [[UIBarButtonItem alloc] initWithTitle:@"140" style:UIBarButtonItemStylePlain target:self action:nil];
    self.textCounter.tintColor = [UIColor lightGrayColor];
    
    self.tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];
    self.tweetButton.tintColor = [UIColor colorWithRed:85.0 / 255.0 green:172.0 / 255.0 blue:238.0 / 255.0 alpha:1];
    self.navigationItem.rightBarButtonItems = @[self.tweetButton,self.textCounter];
    self.navigationItem.leftBarButtonItem = dismissButton;
    [self.tweetButton setEnabled:NO];
    
    
}

-(void) onTweet {

    // submit the tweet and take the user back to the previous view controller
    // if this tweet is a reply to existing tweet?
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /*
    if (self.tweetReply != nil) {
        [params setObject:self.tweetReply.tweetId forKey:@"in_reply_to_status_id"];
    }*/
    //save the tweet into params object with key as status
    [params setObject:self.tweetTextField.text forKey:@"status"];

    [[TwitterClient sharedInstance] postTweetWithParams:params completion:^(Tweet *tweet, NSError *error) {
        
        if(!error) {
            NSLog(@" User has Posted %@", params);
            //post a notification
            [[NSNotificationCenter defaultCenter] postNotificationName:UserPostedNewTweet object:nil userInfo:[NSDictionary dictionaryWithObject:tweet forKey:@"tweet"]];
            // also inform the delegate methods
            if ([self.delegate respondsToSelector:@selector(didPostTweetSuccessfully)]) {
                [self.delegate didPostTweet:tweet];
            }
            else {
                NSLog(@"ERROR cannot send msg to delegate. Check and see if u have assigned the delegate of this viewcontroller");
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Failed to post %@", error);
        }
    }];
    
}

-(void) onDismiss {
    
    // submit the tweet and take the user back to the previous view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
