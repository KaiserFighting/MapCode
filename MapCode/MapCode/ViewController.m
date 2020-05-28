//
//  ViewController.m
//  MapCode
//
//  Created by caesar on 2020/3/25.
//  Copyright © 2020 caesar. All rights reserved.
//

#import "ViewController.h"
#import "MapManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地图";
    NSLog(@"master分支提交");
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 180, 150);
    btn.center = self.view.center;
    [btn setTitle:@"跳转地图" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:40 / 255.0 green:179 / 255.0 blue:124 / 255.0 alpha:1.0];
    [btn addTarget:self action:@selector(jumpToMap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

#pragma mark ============跳转到地图===========
- (void)jumpToMap:(UIButton *)sender{
    MapManager *manager = [MapManager new];
    [manager mapArrayInitWithLatitude:34.1982952700 andLongitude:108.8843675300 andDestinationName:@"锦业时代"];
}



@end
