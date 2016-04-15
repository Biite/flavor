//
//  BFRecipesInfoVC.m
//  Biite
//
//  Created by JRRJ on 3/11/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFRecipesInfoVC.h"
#import "BFRecipeDetailVC.h"
#import "BFSellerInfoVC.h"
#import "BFRecipeOrderVC.h"
#import "BFUser.h"
#import "BFShareMenuVC.h"


@interface BFRecipesInfoVC ()

@property (strong, atomic) NSMutableArray *recipeSets;
@property (nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) BFRecipe *selectedRecipe;

@property (strong, nonatomic) IBOutlet UIImageView *recipeListImageView;
@property (strong, nonatomic) IBOutlet UILabel *recipePriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *recipeCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *recipeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *recipeDescLabel;

@property (strong, nonatomic) IBOutlet UIImageView *sellerPictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sellerRatingImageView;
@property (strong, nonatomic) IBOutlet UILabel *sellerReviewsLabel;

@end


@implementation BFRecipesInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.recipeSets = [[NSMutableArray alloc] init];
    [self.recipeSets addObject:self.recipeInfo];
    
    [self getRecipes];
    
    self.selectedRecipe = self.recipeInfo;
    self.selectedIndex = 0;
    
    [self showRecipeInfo];
    
//    BFUser *seller = self.recipeInfo.recipeSeller;
////    self.sellerPictureImageView = seller.sellerPictureURL;
//    self.sellerPictureImageView.image = [UIImage imageNamed:seller.sellerPictureURL];
//    self.sellerNameLabel.text = [NSString stringWithFormat:@"@%@ is a chef", seller.sellerFirstName];
////    self.sellerRatingImageView.image = seller.sellerRating
//    self.sellerRatingImageView.image = [UIImage imageNamed:seller.sellerRating];
//    self.sellerReviewsLabel.text = [seller.sellerReviews stringByAppendingString:@" reviews"];
    
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

- (void)showRecipeInfo
{
    //    self.recipeListImageView.image = self.selectedRecipe.recipeImageURL
    self.recipeListImageView.image = [UIImage imageNamed:self.selectedRecipe.recipeImageURL];
    self.recipePriceLabel.text = self.selectedRecipe.recipePrice;
    self.recipeDescLabel.text = self.selectedRecipe.recipeDescription;
    
    self.recipeCountLabel.text = [NSString stringWithFormat:@"%ld / %ld", (long)(self.selectedIndex + 1), (long)[self.recipeSets count]];
}

- (void)getRecipes
{
    // API call
    NSArray *result = @[@{
                            @"name": @"Paella Valenciana",
                            //                             @"imageURL": @"http://cloudniary.com/a.jpg",
                            @"imageURL": @"sample_recipe_img0",
                            //                             @"description": @"with fresh seafood and real azafron",
                            @"description": @"This tasty paella has a bit of everything! Wonderfully comforting, flavoursome and colourful.",
                            @"contents": @"Rice, azafron, clams, shrimp, fish, red peppers, onions, garlic, sweet peas, tomatos, olive oil salt and pepper",
                            @"price": @"$25",
                            @"prepareTime": @"45",
                            @"seller": @{
                                    @"name": @"Ricardo Barden",
                                    @"firstName": @"Ricardo",
                                    @"lastName": @"Barden",
                                    //                                         @"pictureURL": @"http://cloudniary.com/profile.jpg",
                                    @"pictureURL": @"sample_profile_img0",
                                    @"backgroundURL": @"profile_background",
                                    @"location": @"Perez McFarland",
                                    @"careers": @"Born in Barcelona, raised in Denver, loves the flavors from the Catelan suisine and seafood in general. This text box should push the content underneath depending on the length.",
                                    //                                         @"rating": @"4.0",
                                    @"rating": @"rating_score_img",
                                    @"reviews": @"46",
                                    }
                            },
                        @{
                            @"name": @"Scallop noodles",
                            //                             @"imageURL": @"http://cloudniary.com/a.jpg",
                            @"imageURL": @"sample_recipe_img1",
                            //                             @"description": @"with fresh seafood and real azafron",
                            @"description": @"This tasty paella has a bit of everything! Wonderfully comforting, flavoursome and colourful.",
                            @"contents": @"Rice, azafron, clams, shrimp, fish, red peppers, onions, garlic, sweet peas, tomatos, olive oil salt and pepper",
                            @"price": @"$35",
                            @"prepareTime": @"55",
                            @"seller": @{
                                    @"name": @"Ricardo Barden",
                                    @"firstName": @"Ricardo",
                                    @"lastName": @"Barden",
                                    //                                         @"pictureURL": @"http://cloudniary.com/profile.jpg",
                                    @"pictureURL": @"sample_profile_img0",
                                    @"backgroundURL": @"profile_background",
                                    @"location": @"Perez McFarland",
                                    @"careers": @"Born in Barcelona, raised in Denver, loves the flavors from the Catelan suisine and seafood in general. This text box should push the content underneath depending on the length.",
                                    //                                         @"rating": @"4.0",
                                    @"rating": @"rating_score_img",
                                    @"reviews": @"46",
                                    }
                            },
                        @{
                            @"name": @"Paella Valenciana",
                            //                             @"imageURL": @"http://cloudniary.com/a.jpg",
                            @"imageURL": @"sample_recipe_img0",
                            //                             @"description": @"with fresh seafood and real azafron",
                            @"description": @"This tasty paella has a bit of everything! Wonderfully comforting, flavoursome and colourful.",
                            @"contents": @"Rice, azafron, clams, shrimp, fish, red peppers, onions, garlic, sweet peas, tomatos, olive oil salt and pepper",
                            @"price": @"$25",
                            @"prepareTime": @"45",
                            @"seller": @{
                                    @"name": @"Ricardo Barden",
                                    @"firstName": @"Ricardo",
                                    @"lastName": @"Barden",
                                    //                                         @"pictureURL": @"http://cloudniary.com/profile.jpg",
                                    @"pictureURL": @"sample_profile_img1",
                                    @"backgroundURL": @"profile_background",
                                    @"location": @"Perez McFarland",
                                    @"careers": @"Born in Barcelona, raised in Denver, loves the flavors from the Catelan suisine and seafood in general. This text box should push the content underneath depending on the length.",
                                    //                                         @"rating": @"4.0",
                                    @"rating": @"rating_score_img",
                                    @"reviews": @"43",
                                    }
                            },
                        @{
                            @"name": @"Scallop noodles",
                            //                             @"imageURL": @"http://cloudniary.com/a.jpg",
                            @"imageURL": @"sample_recipe_img1",
                            //                             @"description": @"with fresh seafood and real azafron",
                            @"description": @"This tasty paella has a bit of everything! Wonderfully comforting, flavoursome and colourful.",
                            @"contents": @"Rice, azafron, clams, shrimp, fish, red peppers, onions, garlic, sweet peas, tomatos, olive oil salt and pepper",
                            @"price": @"$35",
                            @"prepareTime": @"55",
                            @"seller": @{
                                    @"name": @"Ricardo Barden",
                                    @"firstName": @"Ricardo",
                                    @"lastName": @"Barden",
                                    //                                         @"pictureURL": @"http://cloudniary.com/profile.jpg",
                                    @"pictureURL": @"sample_profile_img1",
                                    @"backgroundURL": @"profile_background",
                                    @"location": @"Perez McFarland",
                                    @"careers": @"Born in Barcelona, raised in Denver, loves the flavors from the Catelan suisine and seafood in general. This text box should push the content underneath depending on the length.",
                                    //                                         @"rating": @"4.0",
                                    @"rating": @"rating_score_img",
                                    @"reviews": @"43",
                                    }
                            }
                        ];

    // recipeSets
    // using recipe
    for (NSDictionary *dict in result)
    {
        BFRecipe *recipe = [[BFRecipe alloc] initWithDictionary:dict];
        if (![recipe.recipeName isEqualToString:self.recipeInfo.recipeName])
        {
            [self.recipeSets addObject:recipe];
        }
    }
}

- (IBAction)onClickPrevRecipeDisplay:(id)sender
{
    if (self.selectedIndex == 0)
    {
        self.selectedIndex = [self.recipeSets count] - 1;
    }
    else
    {
        self.selectedIndex = self.selectedIndex - 1;
    }
    
    self.selectedRecipe = [self.recipeSets objectAtIndex:self.selectedIndex];
    [self showRecipeInfo];

}

- (IBAction)onClickNextRecipeDisplay:(id)sender
{
    if (self.selectedIndex == ([self.recipeSets count] - 1))
    {
        self.selectedIndex = 0;
    }
    else
    {
        self.selectedIndex = self.selectedIndex + 1;
    }
    
    self.selectedRecipe = [self.recipeSets objectAtIndex:self.selectedIndex];
    [self showRecipeInfo];
}

- (IBAction)onClickDisplayRecipeDetail:(id)sender
{
    self.selectedIndex = 0;
    [self performSegueWithIdentifier:@"GoToRecipeDetail" sender:sender];
}

- (IBAction)onClickDisplaySellerInfo:(id)sender
{
    [self performSegueWithIdentifier:@"GoToSellerInfo" sender:sender];
}

- (IBAction)onClickRecipeOrder:(id)sender
{
    self.selectedIndex = 0;
    [self performSegueWithIdentifier:@"GoToRecipeOrder" sender:sender];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToShareMenu"])
    {
    }
    else if ([segue.identifier isEqualToString:@"GoToRecipeDetail"])
    {
        BFRecipeDetailVC *detailVC = [segue destinationViewController];
        BFRecipe *info = [self.recipeSets objectAtIndex:self.selectedIndex];
        [detailVC setRecipeInfo:info];
    }
    else if ([segue.identifier isEqualToString:@"GoToSellerInfo"])
    {
        BFSellerInfoVC *sellerVC = [segue destinationViewController];
//        [sellerVC setSellerInfo:self.recipeInfo.recipeSeller];
    }
    else if ([segue.identifier isEqualToString:@"GoToRecipeOrder"])
    {
        BFRecipeOrderVC *orderVC = [segue destinationViewController];
        BFRecipe *info = [self.recipeSets objectAtIndex:self.selectedIndex];
        [orderVC setRecipeInfo:info];
    }
}

@end
