//
//  MainViewController.m
//  LoginAnimation
//
//  Created by Jonzzs on 2017/6/16.
//  Copyright © 2017年 Jonzzs. All rights reserved.
//

#import "MainViewController.h"

#define kBlueColor [UIColor colorWithRed:0.33 green:0.40 blue:0.48 alpha:1.00] // 背景的蓝色

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.view.backgroundColor = kBlueColor;
    
    CGFloat labelHeight = 50;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 2 - labelHeight, self.view.frame.size.width, labelHeight)];
    label.text = @"首页内容";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:25.0f];
    [self.view addSubview:label];
}

@end
