//
//  OutComeViewController.m
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/17.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import "OutComeViewController.h"

@interface OutComeViewController ()

@end

@implementation OutComeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *labelText=nil;
    if(self.HaveWinner)
        labelText = [NSString stringWithFormat:@"The Winner is %@.",self.winner.aname];
    else
        labelText = [NSString stringWithFormat:@"There is no winner in this game."];

        [self.OutComeLabel setText:labelText];
    

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

- (IBAction)Back:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

}
@end
