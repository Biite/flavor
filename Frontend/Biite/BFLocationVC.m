//
//  BFLocationVC.m
//  Biite
//
//  Created by JRRJ on 3/11/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFLocationVC.h"
#import "BFAPI.h"
#import "BFRecipesExploreVC.h"
#import <SVProgressHUD.h>


@interface BFLocationVC () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *location;

@end


@implementation BFLocationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickFindLocation:(id)sender
{
}


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (IBAction)editingChanged:(id)sender
{
}

- (void)hideKeyboard
{
    [self.view endEditing:true];
}

- (IBAction)onClickNext:(id)sender
{
    // location process
    //    if () // failed
    {
        
    }
    //    else  // success
    {
        [self performSegueWithIdentifier:@"GoToRecipesExplore" sender:sender];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToRecipesExplore"])
    {
        
    }
}

@end
