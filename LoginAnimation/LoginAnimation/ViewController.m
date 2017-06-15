//
//  ViewController.m
//  LoginAnimation
//
//  Created by Jonzzs on 2017/6/15.
//  Copyright © 2017年 Jonzzs. All rights reserved.
//

#import "ViewController.h"

CGFloat const leftPadding = 60.0f; // 左边间距

@interface ViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) UILabel *usernameLabel; // 用户名标题
@property (nonatomic, strong) UILabel *passwordLabel; // 密码标题

@property (nonatomic, strong) CAShapeLayer *usernameLine; // 用户名线
@property (nonatomic, strong) CAShapeLayer *passwordLine; // 密码线
@property (nonatomic, strong) CABasicAnimation *lineAnimation; // 线的动画
@property (nonatomic, assign) NSInteger animationTime; // 动画次数

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.33 green:0.40 blue:0.48 alpha:1.00]; // 背景颜色
    
    CGFloat width = self.view.frame.size.width - leftPadding; // 控件宽度
    CGFloat labelHeight = 30.0f; // 标题文字的高度
    CGFloat lineWidth = 1.0f; // 线的宽度
    
    /* 用户名标题 */
    CGFloat usernameLabelY = self.view.center.y - 50;
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, usernameLabelY, width, labelHeight)];
    self.usernameLabel.text = @"USERNAME";
    self.usernameLabel.textColor = [UIColor whiteColor];
    self.usernameLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.view addSubview:self.usernameLabel];
    
    /* 用户名线 */
    CGFloat usernameLineY = usernameLabelY + labelHeight + 10;
    self.usernameLine = [CAShapeLayer layer];
    self.usernameLine.frame = CGRectMake(leftPadding, usernameLineY, width, 0);
    self.usernameLine.lineWidth = lineWidth;
    self.usernameLine.strokeColor = [UIColor whiteColor].CGColor;
    self.usernameLine.fillColor = [UIColor clearColor].CGColor;
    self.usernameLine.path = [self getLineNormalPath];
    [self.view.layer addSublayer:self.usernameLine];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.usernameLabel.transform = CGAffineTransformMakeScale(1, 1);
    [self startLineAnimation:self.usernameLine];
}


/**
 线的默认路径
 
 @return 路径
 */
- (CGPathRef)getLineNormalPath {
    
    CGFloat width = self.view.frame.size.width - leftPadding;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)]; // 设置起点
    [path addQuadCurveToPoint:CGPointMake(width, 0) controlPoint:CGPointMake(width / 2, 0)]; // 设置终点和控制点
    return path.CGPath;
}


/**
 动画的第一个路径点
 
 @return 路径
 */
- (CGPathRef)getLineAnimationPath1 {
    
    CGFloat width = self.view.frame.size.width - leftPadding;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)]; // 设置起点
    [path addQuadCurveToPoint:CGPointMake(width, 0) controlPoint:CGPointMake(width / 2, 60)]; // 设置终点和控制点
    return path.CGPath;
}


/**
 动画的第二个路径点
 
 @return 路径
 */
- (CGPathRef)getLineAnimationPath2 {
    
    CGFloat width = self.view.frame.size.width - leftPadding;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)]; // 设置起点
    [path addQuadCurveToPoint:CGPointMake(width, 0) controlPoint:CGPointMake(width / 2, -40)]; // 设置终点和控制点
    return path.CGPath;
}


/**
 开始线的动画效果
 
 @param line 线对象
 */
- (void)startLineAnimation:(CAShapeLayer *)line {
    
    self.lineAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    self.lineAnimation.duration = 1.5;
    self.lineAnimation.fromValue = (__bridge id _Nullable)([self getLineNormalPath]);
    self.lineAnimation.toValue = (__bridge id _Nullable)([self getLineAnimationPath1]);
    self.lineAnimation.delegate = self;
    self.usernameLine.path = [self getLineAnimationPath1];
    [self.usernameLine addAnimation:self.lineAnimation forKey:@"PathAnimation"];
    self.animationTime ++;
}


/**
 线的动画执行结束
 
 @param anim 动画对象
 @param flag 状态
 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (self.animationTime == 1) {
        
        self.lineAnimation.duration = 0.3;
        self.lineAnimation.fromValue = (__bridge id _Nullable)([self getLineAnimationPath1]);
        self.lineAnimation.toValue = (__bridge id _Nullable)([self getLineAnimationPath2]);
        self.usernameLine.path = [self getLineAnimationPath2];
        [self.usernameLine addAnimation:self.lineAnimation forKey:@"PathAnimation"];
        self.animationTime ++;
        
        [self startLabelAnimation:self.usernameLabel];
    }
    else if (self.animationTime == 2) {
        
        self.lineAnimation.duration = 0.5;
        self.lineAnimation.fromValue = (__bridge id _Nullable)([self getLineAnimationPath2]);
        self.lineAnimation.toValue = (__bridge id _Nullable)([self getLineNormalPath]);
        self.usernameLine.path = [self getLineNormalPath];
        [self.usernameLine addAnimation:self.lineAnimation forKey:@"PathAnimation"];
        self.animationTime = 0;
    }
}


/**
 开始标题的动画效果
 
 @param label 标题对象
 */
- (void)startLabelAnimation:(UILabel *)label {
    
    [self setAnchorPoint:CGPointMake(0, 0) forView:label];
    [UIView animateWithDuration:1 animations:^{
        
        label.transform = CGAffineTransformMakeScale(0.6, 0.6);
    }];
}


/**
 设置缩放围绕的特定点
 
 @param anchorPoint 围绕的点
 @param view 设置的视图
 */
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}


/**
 将缩放围绕的特定点还原为默认
 
 @param view 设置的视图
 */
- (void)setDefaultAnchorPointforView:(UIView *)view {
    
    [self setAnchorPoint:CGPointMake(0.5f, 0.5f) forView:view];
}


/**
 设置状态栏文字颜色
 
 @return 文字颜色
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

@end
