//
//  Record+CoreDataProperties.h
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/19.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Record.h"

NS_ASSUME_NONNULL_BEGIN

@interface Record (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSOrderedSet<Applicant *> *applicant;
@property (nullable, nonatomic, retain) NSOrderedSet<Voter *> *voter;

@end

@interface Record (CoreDataGeneratedAccessors)

- (void)insertObject:(Applicant *)value inApplicantAtIndex:(NSUInteger)idx;
- (void)removeObjectFromApplicantAtIndex:(NSUInteger)idx;
- (void)insertApplicant:(NSArray<Applicant *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeApplicantAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInApplicantAtIndex:(NSUInteger)idx withObject:(Applicant *)value;
- (void)replaceApplicantAtIndexes:(NSIndexSet *)indexes withApplicant:(NSArray<Applicant *> *)values;
- (void)addApplicantObject:(Applicant *)value;
- (void)removeApplicantObject:(Applicant *)value;
- (void)addApplicant:(NSOrderedSet<Applicant *> *)values;
- (void)removeApplicant:(NSOrderedSet<Applicant *> *)values;

- (void)insertObject:(Voter *)value inVoterAtIndex:(NSUInteger)idx;
- (void)removeObjectFromVoterAtIndex:(NSUInteger)idx;
- (void)insertVoter:(NSArray<Voter *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeVoterAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInVoterAtIndex:(NSUInteger)idx withObject:(Voter *)value;
- (void)replaceVoterAtIndexes:(NSIndexSet *)indexes withVoter:(NSArray<Voter *> *)values;
- (void)addVoterObject:(Voter *)value;
- (void)removeVoterObject:(Voter *)value;
- (void)addVoter:(NSOrderedSet<Voter *> *)values;
- (void)removeVoter:(NSOrderedSet<Voter *> *)values;

@end

NS_ASSUME_NONNULL_END
