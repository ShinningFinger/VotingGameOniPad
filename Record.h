//
//  Record.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/19.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Applicant, Voter;

NS_ASSUME_NONNULL_BEGIN

@interface Record : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Record+CoreDataProperties.h"
