//
//  Model2OutcomeViewController.m
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/19.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import "Model2OutcomeViewController.h"

@interface Model2OutcomeViewController ()

@end

@implementation Model2OutcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.label setText:self.result];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

}
@end
