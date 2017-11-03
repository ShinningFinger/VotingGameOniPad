//
//  Voter+CoreDataProperties.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/19.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Voter.h"

NS_ASSUME_NONNULL_BEGIN

@interface Voter (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *preference;
@property (nullable, nonatomic, retain) Record *recordOfVoter;

@end

NS_ASSUME_NONNULL_END
