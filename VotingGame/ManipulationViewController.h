//
//  ManipulationViewController.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/24.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Voter.h"

@interface ManipulationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *Text;

@property (weak, nonatomic) IBOutlet UITextField *Name;

@property (weak, nonatomic) IBOutlet UITextField *Preference;

@property (strong,nonatomic) Voter *voter;

@property (strong,nonatomic) NSMutableArray *possibleWinner;
- (IBAction)DismissKeyboard:(id)sender;

- (IBAction)SaveData:(id)sender;

@end
