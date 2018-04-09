//
//  ZKKViewController.m
//  TheBopLost
//
//  Created by mosaic on 2018/4/8.
//  Copyright © 2018年 mosaic. All rights reserved.
//

#import "ZKKViewController.h"
#import "ZKSearchTableViewController.h"

@interface ZKKViewController ()
@property (weak, nonatomic) IBOutlet UIView *displayerView;
@property (weak, nonatomic) IBOutlet UIButton *bopLostBtn;
@property (weak, nonatomic) IBOutlet UIButton *bopLostShopBtn;
@property (weak, nonatomic) IBOutlet UILabel *ahopLbel;

@end

@implementation ZKKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加设备";
    self.bopLostBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.bopLostBtn.layer.borderWidth = 1.0;
    // 全局的返回按钮不需要文字的设置
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (IBAction)addBopLoastBtn:(UIButton *)sender {
    ZKSearchTableViewController *zkSearchVC = [[ZKSearchTableViewController alloc] init];
    [self.navigationController pushViewController:zkSearchVC animated:YES];
}

- (IBAction)jumpShoppingBtn:(UIButton *)sender {
    ZKLog(@"2");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
