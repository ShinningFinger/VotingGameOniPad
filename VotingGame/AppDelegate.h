//
//  AppDelegate.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/3/26.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Record.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong,nonatomic) Record * record;

@property (strong, nonatomic) NSMutableArray *mark;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

