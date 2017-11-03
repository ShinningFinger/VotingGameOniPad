//
//  AddVoterViewController.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/3/26.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Voter.h"
@interface AddVoterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *Name;

@property (weak, nonatomic) IBOutlet UITextField *Preference;

@property (strong) Voter *voter;
- (IBAction)DismissKeyboard:(id)sender;

- (IBAction)SaveData:(id)sender;

@end
