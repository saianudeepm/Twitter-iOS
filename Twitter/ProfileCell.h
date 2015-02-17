//
//  ProfileCellTableViewCell.h
//  Twitter
//
//  Created by Sai Anudeep Machavarapu on 2/16/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

//setup a delegate for the ui page control
@protocol ProfileCellDelegate <NSObject>

-(void) pageChanged:(UIPageControl *) pageControl;

@end

@interface ProfileCell : UITableViewCell

@property (strong, nonatomic) User *user;
@property (nonatomic,weak) id<ProfileCellDelegate> delegate;
@end
