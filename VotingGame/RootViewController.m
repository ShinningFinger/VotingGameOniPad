//
//  RootViewController.m
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/14.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import "RootViewController.h"

#import "AppDelegate.h"

#import "LoadGameTableViewController.h"

#import "Record.h"

#import "ApplicantTableViewController.h"

@interface RootViewController ()

@property (strong) Record *record;

@property (nonatomic,strong) NSMutableArray *records;

@end

@implementation RootViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


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


- (IBAction)NewGame:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Create a new game !"
                                                                   message:@"Name:"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"OK", nil);
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        textField.placeholder = @"Name";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
        // Stop listening for text changed notifications.
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        AppDelegate *appDelegate= [[UIApplication sharedApplication]delegate];
        
        NSString* date;
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        date = [formatter stringFromDate:[NSDate date]];
        
        _managedObjectContext=[self managedObjectContext];
        self.record = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:_managedObjectContext];
        [self.record setValue:date forKey:@"date"];
        UITextField *name =alert.textFields.firstObject;
        [self.record setValue:name.text forKey:@"name"];
        NSError *error = nil;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"%@ %@", error, [error localizedDescription]);
        }
        appDelegate.record=self.record;
        [self performSegueWithIdentifier:@"NewGame" sender:self];
        // Stop listening for text changed notifications.
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    otherAction.enabled = NO;

    [alert addAction:cancelAction];
    [alert addAction:otherAction];
    [[alert popoverPresentationController] setSourceView:[self view]];
    [[alert popoverPresentationController] setSourceRect:[sender frame]];
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)LoadGame:(id)sender {
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Record"];
    self.records= [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
 
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Load a game !"
//                                                                   message:@"List"
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    
//    LoadGameTableViewController *VC = [[LoadGameTableViewController alloc] init];
//    [[alert popoverPresentationController] setSourceView:[self view]];
//    [[alert popoverPresentationController] setSourceRect:[sender frame]];
//    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *name = alertController.textFields.firstObject;
        UIAlertAction *otherAction = alertController.actions.lastObject;
        otherAction.enabled = name.text.length > 0;
    }
}


@end
