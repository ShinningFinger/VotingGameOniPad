//
//  pickerViewController.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/3/28.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <CoreData/CoreData.h>

@interface pickerViewController : UIViewController

@property (strong) NSMutableArray *preferenceArray;


- (IBAction)Return:(id)sender;
@property (strong) NSString *pre;




@end
