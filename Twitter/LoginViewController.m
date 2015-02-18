//
//  LoginViewController.m
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/8/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "MenuViewController.h"

@interface LoginViewController ()
- (IBAction)onLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *animateView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *animateLogoImageView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([User currentUser]!=nil){
        [self loginUser:[User currentUser]];
    }
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85 green:172 blue:238 alpha:0.5];
    self.navigationController.navigationBar.translucent = NO;
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

- (IBAction)onLogin:(id)sender {
    //clean up the saved tokens state
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        NSLog(@"Logged in ");
        if(user!=nil){
            
            [self loginUser:user];
        }
        else{
            //present modally the error view
        }
        
    }];
    
}

- (void) loginUser: (User *) user{

    [self.loginButton setHidden:YES];
    [self.logoImageView setHidden:YES];
    [self.animateView setHidden:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //do the animation and present the view
    [UIView animateWithDuration:0.5 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(0.8,0.8);
        [self.animateLogoImageView setTransform:transform];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeScale(32, 32);
            [self.animateView setTransform:transform];
        } completion:^(BOOL finished) {
            [self.animateView setHidden:YES];
            //Modally present the tweets view (logged in view)
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[MenuViewController alloc] init]];
            [self presentViewController:nvc animated:YES completion:nil];
            NSLog(@"welcome to user : %@",user.name);
        }];
    }];


}
@end
