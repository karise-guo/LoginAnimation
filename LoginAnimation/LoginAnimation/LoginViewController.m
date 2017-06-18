//
//  ViewController.m
//  LoginAnimation
//
//  Created by Jonzzs on 2017/6/15.
//  Copyright © 2017年 Jonzzs. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"

CGFloat const leftPadding = 60.0f; // 左边间距
CGFloat const topPadding = 50.0f; // 上下间距

CGFloat const labelHeight = 30.0f; // 标题文字的高度
CGFloat const labelAnimationDuration = 0.8; // 标题的动画时间
CGFloat const labelScaling = 0.8; // 标题的缩放比例

CGFloat const lineWidth = 1.0f; // 线的宽度
CGFloat const lineNormalControlY = 0; // 线的默认控制点
CGFloat const lineAnimationControlY1 = 60; // 线的动画控制点1
CGFloat const lineAnimationControlY2 = -40; // 线的动画控制点2
CGFloat const lineAnimationDuration1 = 0.6; // 线的动画时间1
CGFloat const lineAnimationDuration2 = 0.2; // 线的动画时间2
CGFloat const lineAnimationDuration3 = 0.3; // 线的动画时间3

CGFloat const textFieldHeight = 30.0f; // 输入框高度

CGFloat const buttonHeight = 40.0f; // 登录按钮高度
CGFloat const buttonAnimationDuration = 0.6; // 登录按钮的动画时间

CGFloat const normalAnimationDuration = 0.3; // 默认动画时间

#define kBlueColor [UIColor colorWithRed:0.33 green:0.40 blue:0.48 alpha:1.00] // 背景的蓝色
#define kGreenColor [UIColor colorWithRed:0.34 green:0.61 blue:0.60 alpha:1.00] // 线的绿色
#define kPurpleColor [UIColor colorWithRed:0.48 green:0.49 blue:0.83 alpha:1.00] // 按钮的紫色

@interface LoginViewController ()<CAAnimationDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UILabel *usernameLabel; // 用户名标题
@property (nonatomic, strong) UILabel *passwordLabel; // 密码标题

@property (nonatomic, strong) CAShapeLayer *usernameLine; // 用户名线
@property (nonatomic, strong) CAShapeLayer *passwordLine; // 密码线

@property (nonatomic, strong) UITextField *usernameTextField; // 用户名输入框
@property (nonatomic, strong) UITextField *passwordTextField; // 密码输入框

@property (nonatomic, strong) UIButton *loginButton; // 登录按钮

@property (nonatomic, assign) BOOL usernameIsEdit; // 用户名正在编辑
@property (nonatomic, assign) BOOL passwordIsEdit; // 密码正在编辑

@property (nonatomic, assign) NSInteger animationTime; // 动画次数

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBlueColor; // 背景颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent; // 状态栏
    
    /* 设置导航栏 */
    self.title = @"登录";
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    /* 初始化视图 */
    [self initViews];
    
    /* 增加监听（当键盘出现或改变时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    /* 增加监听（当键盘退出时） */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self startButtonAnimation:NO]; // 还原页面
}


/**
 初始化视图
 */
- (void)initViews {
    
    CGFloat width = self.view.frame.size.width - leftPadding; // 控件宽度
    UIFont *labelFont = [UIFont systemFontOfSize:17.0f]; // 标题文字大小
    UIFont *textFieldFont = [UIFont systemFontOfSize:14.0f]; // 输入框文字大小
    UIFont *buttonFont = [UIFont systemFontOfSize:15.0f]; // 登录按钮文字大小
    
    /* 用户名标题 */
    CGFloat usernameLabelY = self.view.center.y - 100;
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, usernameLabelY, width, labelHeight)];
    self.usernameLabel.text = @"USERNAME";
    self.usernameLabel.textColor = [UIColor whiteColor];
    self.usernameLabel.font = labelFont;
    self.usernameLabel.userInteractionEnabled = YES;
    [self.view addSubview:self.usernameLabel];
    
    /* 添加用户名点击事件 */
    UITapGestureRecognizer *usernameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usernameTapDo)];
    [self.usernameLabel addGestureRecognizer:usernameTap];
    
    /* 用户名线 */
    CGFloat usernameLineY = usernameLabelY + labelHeight + 5;
    self.usernameLine = [CAShapeLayer layer];
    self.usernameLine.frame = CGRectMake(leftPadding, usernameLineY, width, 0);
    self.usernameLine.lineWidth = lineWidth; // 线宽
    self.usernameLine.strokeColor = [UIColor whiteColor].CGColor; // 线的颜色
    self.usernameLine.fillColor = [UIColor clearColor].CGColor; // 填充色
    self.usernameLine.path = [self getBezierPath:lineNormalControlY];
    [self.view.layer addSublayer:self.usernameLine];
    
    /* 用户名输入框 */
    CGFloat usernameTextFieldY = usernameLineY - textFieldHeight;
    self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftPadding, usernameTextFieldY, width, textFieldHeight)];
    self.usernameTextField.textColor = [UIColor whiteColor];
    self.usernameTextField.tintColor = kGreenColor;
    self.usernameTextField.font = textFieldFont;
    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameTextField.enabled = NO;
    self.usernameTextField.delegate = self;
    [self.view addSubview:self.usernameTextField];
    
    /* 密码标题 */
    CGFloat passwordLabelY = usernameLineY + topPadding;
    self.passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, passwordLabelY, width, labelHeight)];
    self.passwordLabel.text = @"PASSWORD";
    self.passwordLabel.textColor = [UIColor whiteColor];
    self.passwordLabel.font = labelFont;
    self.passwordLabel.userInteractionEnabled = YES;
    [self.view addSubview:self.passwordLabel];
    
    /* 添加密码点击事件 */
    UITapGestureRecognizer *passwordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordTapDo)];
    [self.passwordLabel addGestureRecognizer:passwordTap];
    
    /* 密码线 */
    CGFloat passwordLineY = passwordLabelY + labelHeight + 5;
    self.passwordLine = [CAShapeLayer layer];
    self.passwordLine.frame = CGRectMake(leftPadding, passwordLineY, width, 0);
    self.passwordLine.lineWidth = lineWidth; // 线宽
    self.passwordLine.strokeColor = [UIColor whiteColor].CGColor; // 线的颜色
    self.passwordLine.fillColor = [UIColor clearColor].CGColor; // 填充色
    self.passwordLine.path = [self getBezierPath:lineNormalControlY];
    [self.view.layer addSublayer:self.passwordLine];
    
    /* 密码输入框 */
    CGFloat passwordTextFieldY = passwordLineY - textFieldHeight;
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftPadding, passwordTextFieldY, width, textFieldHeight)];
    self.passwordTextField.textColor = [UIColor whiteColor];
    self.passwordTextField.tintColor = kGreenColor;
    self.passwordTextField.font = textFieldFont;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.enabled = NO;
    self.passwordTextField.delegate = self;
    [self.view addSubview:self.passwordTextField];
    
    /* 登录按钮 */
    CGFloat loginButtonY = passwordLineY + topPadding;
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(leftPadding, loginButtonY, width, buttonHeight)];
    self.loginButton.titleLabel.font = buttonFont;
    [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:kPurpleColor];
    [self.loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    [self.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
}


/**
 用户名点击事件
 */
- (void)usernameTapDo {
    
    self.usernameIsEdit = YES;
    self.passwordIsEdit = NO;
    [self startLineAnimation];
}


/**
 密码点击事件
 */
- (void)passwordTapDo {
    
    self.usernameIsEdit = NO;
    self.passwordIsEdit = YES;
    [self startLineAnimation];
}


/**
 获取贝塞尔曲线路径

 @param controlY 控制点的 Y 值
 @return 曲线路径
 */
- (CGPathRef)getBezierPath:(CGFloat)controlY {
    
    CGFloat width = self.view.frame.size.width - leftPadding;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)]; // 设置起点
    [path addQuadCurveToPoint:CGPointMake(width, 0) controlPoint:CGPointMake(width / 2, controlY)]; // 设置终点和控制点
    return path.CGPath;
}


/**
 开始线的动画效果
 */
- (void)startLineAnimation {
    
    CAShapeLayer *lineLayer = self.usernameIsEdit? self.usernameLine : self.passwordLine;
    
    /* 第一段动画 */
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.duration = lineAnimationDuration1;
    animation.fromValue = (__bridge id _Nullable)([self getBezierPath:lineNormalControlY]);
    animation.toValue = (__bridge id _Nullable)([self getBezierPath:lineAnimationControlY1]);
    [lineLayer addAnimation:animation forKey:@"PathAnimation"];
    self.animationTime ++;
}


/**
 线的动画执行结束（代理方法）
 
 @param anim 动画对象
 @param flag 状态
 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    CAShapeLayer *lineLayer = self.usernameIsEdit? self.usernameLine : self.passwordLine;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    
    /* 第二段动画 */
    if (self.animationTime == 1) {
        
        animation.duration = lineAnimationDuration2;
        animation.fromValue = (__bridge id _Nullable)([self getBezierPath:lineAnimationControlY1]);
        animation.toValue = (__bridge id _Nullable)([self getBezierPath:lineAnimationControlY2]);
        [lineLayer addAnimation:animation forKey:@"PathAnimation"];
        self.animationTime ++;
        
        [self startLabelAnimation:YES]; // 开始标题缩小的动画效果
    }
    /* 第三段动画 */
    else if (self.animationTime == 2) {
        
        animation.duration = lineAnimationDuration3;
        animation.fromValue = (__bridge id _Nullable)([self getBezierPath:lineAnimationControlY2]);
        animation.toValue = (__bridge id _Nullable)([self getBezierPath:lineNormalControlY]);
        [lineLayer addAnimation:animation forKey:@"PathAnimation"];
        self.animationTime = 0;
    }
}


/**
 开始标题缩放的动画效果

 @param isShrink 是否缩小
 */
- (void)startLabelAnimation:(BOOL)isShrink {
    
    UILabel *label = self.usernameIsEdit? self.usernameLabel : self.passwordLabel;
    UITextField *textField = self.usernameIsEdit? self.usernameTextField : self.passwordTextField;
    [self setAnchorPoint:CGPointMake(0, 0) forView:label]; // 设置缩放围绕的点
    [UIView animateWithDuration:labelAnimationDuration animations:^{
        
        CGFloat scaling = isShrink? labelScaling : 1; // 缩放比例
        label.transform = CGAffineTransformMakeScale(scaling, scaling);
        
        CGFloat padding = isShrink? -15 : 15; // 偏移距离
        CGRect frame =  label.frame;
        frame.origin.y += padding;
        label.frame = frame;
        
    } completion:^(BOOL finished) {
        
        label.userInteractionEnabled = !isShrink;
        textField.enabled = isShrink;
        if (isShrink) {
            
            [textField becomeFirstResponder];
        }
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
 输入框开始编辑（代理方法）

 @param textField 输入框
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    /* 改变线的颜色 */
    if (textField == self.usernameTextField) {
        
        self.usernameIsEdit = YES;
        self.passwordIsEdit = NO;
        self.usernameLine.strokeColor = kGreenColor.CGColor;
    }
    else if (textField == self.passwordTextField) {
        
        self.usernameIsEdit = NO;
        self.passwordIsEdit = YES;
        self.passwordLine.strokeColor = kGreenColor.CGColor;
    }
}


/**
 输入框结束编辑（代理方法）

 @param textField 输入框
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    /* 开始标题还原的动画效果 */
    if (textField.text.length == 0) {
        
        [self startLabelAnimation:NO];
    }
    
    /* 改变线的颜色 */
    if (textField == self.usernameTextField) {
        
        self.usernameLine.strokeColor = [UIColor whiteColor].CGColor;
    }
    else if (textField == self.passwordTextField) {
        
        self.passwordLine.strokeColor = [UIColor whiteColor].CGColor;
    }
}


/**
 点击登录按钮
 */
- (void)loginAction {
    
    [self.view endEditing:YES];
    [self startButtonAnimation:YES]; // 开始登录按钮的动画
}


/**
 开始登录按钮的动画

 @param enabled 是否生效，NO 表示还原页面
 */
- (void)startButtonAnimation:(BOOL)enabled {
    
    [UIView animateWithDuration:buttonAnimationDuration animations:^{
        
        self.usernameLabel.alpha = !enabled;
        self.usernameLine.hidden = enabled;
        self.usernameTextField.alpha = !enabled;
        self.passwordLabel.alpha = !enabled;
        self.passwordLine.hidden = enabled;
        self.passwordTextField.alpha = !enabled;
        self.loginButton.titleLabel.alpha = !enabled;
        
        CGRect frame = self.loginButton.frame;
        frame.size.height = enabled? 5 : buttonHeight;
        self.loginButton.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:buttonAnimationDuration animations:^{
            
            CGFloat width = self.view.frame.size.width - leftPadding;
            self.loginButton.transform = CGAffineTransformMakeTranslation(enabled? width : 0, 0);
            
        } completion:^(BOOL finished) {
            
            if (enabled) {
                
                [self startLogin];
            }
        }];
    }];
}


/**
 开始登录
 */
- (void)startLogin {
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    [self.navigationController pushViewController:mainViewController animated:YES];
}


/**
 点击空白结束编辑
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


/**
 *  键盘弹出
 */
- (void)keyboardWillShow:(NSNotification *)aNotification {
    
    /* 获取键盘的高度 */
    NSDictionary *userInfo = aNotification.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = aValue.CGRectValue;
    
    /* 输入框上移 */
    CGFloat padding = 20;
    CGRect frame = self.loginButton.frame;
    CGFloat height = self.view.frame.size.height - frame.origin.y - frame.size.height;
    if (height < keyboardRect.size.height + padding) {
        
        [UIView animateWithDuration:normalAnimationDuration animations:^ {
            
            CGRect frame = self.view.frame;
            frame.origin.y = -(keyboardRect.size.height - height + padding);
            self.view.frame = frame;
        }];
    }
}


/**
 *  键盘退出
 */
- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    /* 输入框下移 */
    [UIView animateWithDuration:normalAnimationDuration animations:^ {
        
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
}


@end
