//
//  RootViewController.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/14.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RootViewController : UIViewController

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (IBAction)NewGame:(id)sender;
- (IBAction)LoadGame:(id)sender;



@end
