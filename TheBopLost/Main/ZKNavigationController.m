//
//  ZKNavigationController.m
//  蓝牙电子锁
//
//  Created by mosaic on 2017/12/12.
//  Copyright © 2017年 mosaic. All rights reserved.
//

#import "ZKNavigationController.h"

@interface ZKNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, getter=isPushing) BOOL pushing;

@end

@implementation ZKNavigationController

+ (void)initialize
{
    UINavigationBar *Bar = [UINavigationBar appearance];
    Bar.barTintColor = [UIColor colorWithRed:242/255.0 green:18/255.0 blue:76/255.0 alpha:1.0];//[ConfigureFile getConfigColor:@"COLOR_NAV_BAR_BARTINT"];
    //返回按钮的箭头颜色
    Bar.tintColor = [UIColor whiteColor];
//    Bar.translucent = NO;
    //
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -20)
//                                                         forBarMetrics:UIBarMetricsDefault];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //白底黑字
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.pushing == YES) {
        return;
    } else {
        self.pushing = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.pushing = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
