//
//  MainViewController.m
//  LoginAnimation
//
//  Created by Jonzzs on 2017/6/16.
//  Copyright © 2017年 Jonzzs. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat labelHeight = 50;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 2 - labelHeight, self.view.frame.size.width, labelHeight)];
    label.text = self.title;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:25.0f];
    [self.view addSubview:label];
}

@end
