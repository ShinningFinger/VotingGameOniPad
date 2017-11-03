//
//  CountViewController.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/3/30.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *ManipulationButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
