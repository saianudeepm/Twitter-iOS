//
//  MenuViewController.m
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/16/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "MenuViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "MentionsViewController.h"

const  NSInteger RIGHT_BORDER =300;

@interface MenuViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong,nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic) NSArray *navViewControllers;
@property (strong, nonatomic) NSArray *viewControllers;

@property (strong, nonatomic) TweetsViewController *tweetsViewController;
@property (strong, nonatomic) ProfileViewController *profileViewController;
@property (strong, nonatomic) MentionsViewController *mentionsViewController;

-(void) setContentViewController:(UIViewController *)viewController;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85.0 / 255.0 green:172.0 / 255.0 blue:238.0 / 255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = @"Options";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:85.0 / 255.0 green:172.0 / 255.0 blue:238.0 / 255.0 alpha:1]];
    [self.navigationController setNavigationBarHidden:NO];
    [self setupViewControllers];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor colorWithRed:136.0/255.0 green:153.0/255.0 blue:166.0/255.0 alpha:1];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"Profile";
            break;
        case 1:
            cell.textLabel.text=@"Home Timeline";
            break;
        case 2:
            cell.textLabel.text=@"Mentions";
            break;
            
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.bounds.size.height /3;
}

#pragma mark - table delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self setContentViewController: self.navViewControllers[0]];
            break;
        case 1:
            [self setContentViewController: self.navViewControllers[1]];
            break;
        case 2:
            [self setContentViewController: self.navViewControllers[2]];
            break;
            
    }
}

#pragma mark -private methods
-(void) setupViewControllers {
    
    self.tweetsViewController = [[TweetsViewController alloc] init];
    self.profileViewController= [[ProfileViewController alloc]init];
    self.mentionsViewController = [[MentionsViewController alloc]init];
    
    self.viewControllers = [NSArray arrayWithObjects:self.profileViewController,self.tweetsViewController, nil];
    
    UINavigationController *tunc = [[UINavigationController alloc] initWithRootViewController: self.tweetsViewController];
    UINavigationController *punc = [[UINavigationController alloc]initWithRootViewController: self.profileViewController ];
    UINavigationController *munc = [[UINavigationController alloc]initWithRootViewController:self.mentionsViewController];
    
    self.navViewControllers = [NSArray arrayWithObjects:punc,tunc,munc,nil];
    //push table view into the stack
    [self.contentView addSubview:self.tableView];
    
    [self setContentViewController:punc];
    /*
     // set Home Timeline as the initial view
     self.currentViewController= tunc;
     //set the framesize of the currentview controller to that of contentview
     self.currentViewController.view.frame = self.contentView.bounds;
     [self.contentView addSubview:tunc];
     */
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    UIViewController *viewController = self.currentViewController;
    
    CGRect frame =  viewController.view.frame;
    
    if(fabsf(translation.x) > fabsf(translation.y)){
        if(translation.x>0 && frame.origin.x<RIGHT_BORDER){
            frame.origin.x = translation.x;
            NSLog(@"setting frame origin to %f",translation.x);
            viewController.view.frame=frame;
        }
        else if (translation.x<0 && frame.origin.x>0){
            NSLog(@"else if setting frame origin to %f",translation.x);
            frame.origin.x = RIGHT_BORDER+ translation.x;
            viewController.view.frame=frame;
        }
        
    }
    
    
    if(sender.state == UIGestureRecognizerStateBegan){
        // NSLog(@"gesture began");
        
        
    }else if(sender.state == UIGestureRecognizerStateChanged){
        // NSLog(@"gesture changed");
        
    }else if(sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"velocity x= %f velocity y=%f",velocity.x, velocity.y);
        if(velocity.x >0 && fabsf(velocity.x) > fabsf(velocity.y)){
            CGRect frame = self.currentViewController.view.frame;
            frame.origin.x = RIGHT_BORDER;
            NSLog(@"closing frame to right with translation to %f",translation.x);
            [UIView animateWithDuration:0.6 animations:^{
                [self.navigationController setNavigationBarHidden:NO];
                viewController.view.frame=frame;
            }completion:^(BOOL finished) {
                
            }];
            
            
        }else if(velocity.x < 0 && fabsf(velocity.x) > fabsf(velocity.y) ){
            CGRect frame = self.currentViewController.view.frame;
            frame.origin.x = 0;
            NSLog(@"closing frame to left with translation to %f",translation.x);
            [UIView animateWithDuration:0.6 animations:^{
                [self.navigationController setNavigationBarHidden:YES];
                viewController.view.frame=frame;
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
        NSLog(@"gesture ended");
        
        
    }
}

// called when clicked on the menu button to pull in the respective view controller
-(void) setContentViewController:(UIViewController *)viewController{
    //push table view into the stack
    [self.contentView addSubview:self.tableView];
    [self.navigationController setNavigationBarHidden:YES];
    self.currentViewController= viewController;
    //set the framesize of the currentview controller to that of contentview
    self.currentViewController.view.frame = self.contentView.bounds;
    CGRect frame = self.currentViewController.view.frame;
    frame.origin.x = 0;
    self.currentViewController.view.frame = frame;
    [self.contentView addSubview:self.currentViewController.view];
    //[self.currentViewController didMoveToParentViewController:self];
    
    
}


@end
