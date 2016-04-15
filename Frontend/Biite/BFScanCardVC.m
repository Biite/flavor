//
//  BFScanCardVC.m
//  Biite
//
//  Created by JRRJ on 3/15/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFScanCardVC.h"


@interface BFScanCardVC ()

@end


@implementation BFScanCardVC

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

- (IBAction)onClickBtnCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnManual:(id)sender
{

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"GoToScanCard"])
//    {
//        //        BFScanCardVC *orderVC = [segue destinationViewController];
//        //        NSDictionary *dicRecipeInfo = [self.recipeSets objectAtIndex:selectedRow];
//        //        [detailVC setRecipeDetail:dicRecipeInfo];
//    }
}

@end
