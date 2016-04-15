//
//  BFRecipeDetailVC.m
//  Biite
//
//  Created by JRRJ on 3/15/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFRecipeDetailVC.h"
#import "BFUser.h"
#import "BFSellerInfoVC.h"
#import "BFShareMenuVC.h"
#import "BFRecipeOrderVC.h"


@interface BFRecipeDetailVC ()

@property (strong, nonatomic) IBOutlet UIImageView *sellerPictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sellerRatingImageView;
@property (strong, nonatomic) IBOutlet UILabel *sellerReviewsLabel;

@property (strong, nonatomic) IBOutlet UILabel *recipeContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *recipePrepareTimeLabel;

@end


@implementation BFRecipeDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    BFUser *seller = self.recipeInfo.recipeSeller;
//    self.sellerPictureImageView.image = [UIImage imageNamed:seller.sellerPictureURL];
//    self.sellerNameLabel.text = [NSString stringWithFormat:@"@%@ is a chef", seller.sellerFirstName];
//    //    self.sellerRatingImageView.image = seller.sellerRating
//    self.sellerRatingImageView.image = [UIImage imageNamed:seller.sellerRating];
//    self.sellerReviewsLabel.text = [seller.sellerReviews stringByAppendingString:@" reviews"];
//    
//    self.recipeContentLabel.text = self.recipeInfo.recipeContents;
//    self.recipePrepareTimeLabel.text = self.recipeInfo.prepareTime;
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

- (IBAction)onClickSocialShare:(id)sender
{
    [self performSegueWithIdentifier:@"GoToShareMenu" sender:sender];
}

- (IBAction)onClickDisplaySellerInfo:(id)sender
{
    [self performSegueWithIdentifier:@"GoToSellerInfo" sender:sender];
}

- (IBAction)onClickRecipeOrder:(id)sender
{
    //    UIButton *selectedButton = (UIButton *)sender;
    //    selectedRow = (selectedButton.tag - 1) / 10;
    //    NSLog(@"Selected Row Index : %ld", (long)selectedRow);
    
    [self performSegueWithIdentifier:@"GoToRecipeOrder" sender:sender];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToShareMenu"])
    {
    }
    else if ([segue.identifier isEqualToString:@"GoToSellerInfo"])
    {
        BFSellerInfoVC *sellerVC = [segue destinationViewController];
//        [sellerVC setSellerInfo:self.recipeInfo.recipeSeller];
    }
    else if ([segue.identifier isEqualToString:@"GoToRecipeOrder"])
    {
        BFRecipeOrderVC *orderVC = [segue destinationViewController];
        [orderVC setRecipeInfo:self.recipeInfo];
    }
}

@end
