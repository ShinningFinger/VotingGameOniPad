//
//  AddApplicantViewController.m
//  VotingGame
//
//  Created by Xavier Zhu on 16/3/26.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import "AddApplicantViewController.h"

#import "Applicant.h"

#import "AppDelegate.h"

#import "Record.h"

#import <CoreData/CoreData.h>

@interface AddApplicantViewController ()

@property (strong,nonatomic) NSMutableArray *Applicants;

@property (strong,nonatomic) NSMutableArray *voters;

@property (strong,nonatomic) NSMutableArray *records;


@end

@implementation AddApplicantViewController

@synthesize applicant;

-(NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.applicant) {
        [self.Name setText:[self.applicant valueForKey:@"aname"]];
    }

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

- (IBAction)SaveData:(id)sender {
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    AppDelegate *appDelegate= [[UIApplication sharedApplication]delegate];
    Record *record = appDelegate.record;
    self.Applicants=(NSMutableArray*)record.applicant;
    self.voters= (NSMutableArray*)record.voter;

    NSString *name= [[[self Name]text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL a=true;
    if (self.applicant) {
        for (int i=0; i<self.Applicants.count;i++){
            Applicant *Applicant= [self.Applicants objectAtIndex:i];
            if (Applicant!=self.applicant) {
                NSString *aname= [Applicant valueForKey:@"aname" ];
                if ([name isEqualToString:aname]) {
                    NSString *message=[NSString stringWithFormat:@"There exists the same candidate, please select another name."];
                    [self displayErrorMessage:message :sender];
                    a=false;
                }
            }
        }
        if(a){
            if([[self.Name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0){
                NSString *message =[NSString stringWithFormat:@"You have not entered candidate's name"];
                [self displayErrorMessage:message :sender];
            }
            else if (self.voters.count!=0 && ![self.Name.text isEqualToString:self.applicant.aname]) {
                NSString *message=[NSString stringWithFormat:@"You are editing an candidate. Note that you have set the preference before. Please change the preference order for each voter."];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notes"
                                                                               message:message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"Get it."
                                                          style:UIAlertActionStyleDefault
                                                        handler:^void (UIAlertAction *action) {
                                                            [self.applicant setValue:self.Name.text forKey:@"aname"];                                                            [self.navigationController popViewControllerAnimated:YES];
                                                        }]];
                [[alert popoverPresentationController] setSourceView:[self view]];
                [[alert popoverPresentationController] setSourceRect:[sender frame]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
                [self.applicant setValue:self.Name.text forKey:@"aname"];
        }
    } else {
        for (int i=0; i<self.Applicants.count;i++){
            Applicant *Applicant= [self.Applicants objectAtIndex:i];
            NSString *aname= [Applicant valueForKey:@"aname" ];
            if ([name isEqualToString:aname]) {
                NSString *message=[NSString stringWithFormat:@"There exists the same candidate, please select another name."];
                [self displayErrorMessage:message :sender];
                a=false;
            }

        }
        if(a){
            if([[self.Name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0){
                NSString *message =[NSString stringWithFormat:@"You have not entered candidate's name"];
                [self displayErrorMessage:message :sender];
            }
            else if (self.voters.count!=0) {
                NSString *message=[NSString stringWithFormat:@"You are adding a new candidate. Please change the preference order for each voter."];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notes"
                                                                               message:message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"Get it."
                                                          style:UIAlertActionStyleDefault
                                                        handler:^void (UIAlertAction *action) {
                                                            Applicant *newApplicant = [NSEntityDescription insertNewObjectForEntityForName:@"Applicant" inManagedObjectContext:context];
                                                            [newApplicant setRecordOfApplicant:record];

                                                            [newApplicant setValue:self.Name.text forKey:@"aname"];
                                                            NSError *error = nil;
                                                            
                                                            if (![context save:&error]) {
                                                                NSLog(@"%@ %@", error, [error localizedDescription]);
                                                            }
                                                            [self.navigationController popViewControllerAnimated:YES];
                                                        }]];
                [[alert popoverPresentationController] setSourceView:[self view]];
                [[alert popoverPresentationController] setSourceRect:[sender frame]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            else{
                
                
                Applicant *newApplicant = [NSEntityDescription insertNewObjectForEntityForName:@"Applicant" inManagedObjectContext:context];
                [newApplicant setRecordOfApplicant:record];
                
                [newApplicant setValue:[self.Name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"aname"];

                
                NSError *error = nil;
                
                if (![context save:&error]) {
                    NSLog(@"%@ %@", error, [error localizedDescription]);
                }
            }
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)DismissKeyboard:(id)sender {
    [self resignFirstResponder];

}

-(void)displayErrorMessage: (NSString *)message :(id)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                            }]];
    [[alert popoverPresentationController] setSourceView:[self view]];
    [[alert popoverPresentationController] setSourceRect:[sender frame]];
    [self presentViewController:alert animated:YES completion:nil];

}
@end
