//
//  AddApplicantViewController.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/3/26.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Applicant.h"

@interface AddApplicantViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *Name;
- (IBAction)SaveData:(id)sender;

- (IBAction)DismissKeyboard:(id)sender;
@property (strong) Applicant *applicant;

@end
