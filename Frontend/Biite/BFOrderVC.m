//
//  BFOrderVC.m
//  Biite
//
//  Created by JRRJ on 3/15/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFOrderVC.h"
#import "BFScanCardVC.h"


@interface BFOrderVC ()

@end


@implementation BFOrderVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnScanCard:(id)sender
{
    //    UIButton *selectedButton = (UIButton *)sender;
    //    selectedRow = (selectedButton.tag - 1) / 10;
    //    NSLog(@"Selected Row Index : %ld", (long)selectedRow);
    
    [self performSegueWithIdentifier:@"GoToScanCard" sender:sender];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToScanCard"])
    {
        //        BFScanCardVC *orderVC = [segue destinationViewController];
        //        NSDictionary *dicRecipeInfo = [self.recipeSets objectAtIndex:selectedRow];
        //        [detailVC setRecipeDetail:dicRecipeInfo];
    }
}

@end
