//
//  BFRecipesExploreVC.m
//  Biite
//
//  Created by JRRJ on 3/11/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFRecipesExploreVC.h"
#import "BFRecipesTableCell.h"
#import "BFRecipe.h"
#import "BFMyUser.h"
#import "BFUser.h"
#import "BFRecipesInfoVC.h"
#import "BFSellerInfoVC.h"
#import "BFLoginVC.h"
#import "BFUserVC.h"
#import "BFOrderMenuVC.h"
#import "BFSearchFilterVC.h"
#import <SDWebImage/SDWebImageManager.h>


@interface BFRecipesExploreVC () <UITableViewDataSource, UITableViewDelegate>

//@property (strong, atomic) NSMutableOrderedSet *recipeSets;
@property (strong, atomic) NSMutableArray *recipeSets;

@property (strong, nonatomic) IBOutlet UITableView *recipesTableView;
@property (nonatomic) NSInteger selectedIndex;

@end


@implementation BFRecipesExploreVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.recipeSets = [NSMutableOrderedSet new];
    self.recipeSets = [[NSMutableArray alloc] init];
    [self getRecipes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showSetting:(id)sender
{
    if (![BFMyUser isLoggedIn])
    {
        [self performSegueWithIdentifier:@"GoToLogin" sender:sender];
    }
    else
    {
        [self performSegueWithIdentifier:@"GoToUserMenu" sender:sender];
    }
}

- (IBAction)showOrderedMenu:(id)sender
{
    [self performSegueWithIdentifier:@"GoToOrderMenu" sender:sender];
}

- (IBAction)showSearchFilter:(id)sender
{
    [self performSegueWithIdentifier:@"GoToSearchFilter" sender:sender];
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
                                    //                                         @"backgroundURL": @"http://cloudniary.com/profile.jpg",
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
    for (NSDictionary *dict in result)
    {
        BFRecipe *recipe = [[BFRecipe alloc] initWithDictionary:dict];
        [self.recipeSets addObject:recipe];
    }
}


#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recipeSets count];
}

- (BFRecipesTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellForRecipes";
    BFRecipesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[BFRecipesTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    BFRecipe *recipe = [self.recipeSets objectAtIndex:indexPath.row];
    
    cell.recipeName.text = recipe.recipeName;
    cell.prepareTime.text = [recipe.prepareTime stringByAppendingString:@" mins"];
    cell.recipeDesc.text = recipe.recipeDescription;
    cell.price.text = recipe.recipePrice;
    
    cell.btnRecipe.tag = indexPath.row;
    [cell.btnRecipe addTarget:self action:@selector(displayRecipesInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnProfile.tag = indexPath.row;
    [cell.btnProfile addTarget:self action:@selector(displaySellerInfo:) forControlEvents:UIControlEventTouchUpInside];
    
//    NSString *recipeImageURL = recipe.recipeImageURL;
//    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:recipeImageURL]
//                                                    options:SDWebImageRefreshCached
//                                                   progress:nil
//                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
//     {
//         if (image != NULL)
//         {
//             cell.recipeImage.image = image;
//         }
//     }];
    cell.recipeImage.image = [UIImage imageNamed:recipe.recipeImageURL];
    
//    NSString *profileImageURL = recipe.recipeSeller.sellerPictureURL;
//    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:profileImageURL]
//                                                    options:SDWebImageRefreshCached
//                                                   progress:nil
//                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
//    {
//        if (image != NULL)
//        {
//            cell.profileImage.image = image;
//        }
//    }];
    
    
//    cell.profileImage.image = [UIImage imageNamed:recipe.recipeSeller.sellerPictureURL];
    
    return cell;
}

- (void)displayRecipesInfo:(UIButton *)sender
{
    self.selectedIndex = sender.tag;
    [self performSegueWithIdentifier:@"GoToRecipesInfo" sender:sender];
}

- (void)displaySellerInfo:(UIButton *)sender
{
    self.selectedIndex = sender.tag;
    [self performSegueWithIdentifier:@"GoToSellerInfo" sender:sender];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToSearchFilter"])
    {
//        CATransition* transition = [CATransition animation];
//        transition.duration = 1;
//        transition.type = kCATransitionFade;
//        transition.subtype = kCATransitionFromBottom;
//        
//        [self.view.window.layer addAnimation:transition forKey:kCATransition];
        
        BFSearchFilterVC * searchFilterVC = [segue destinationViewController];
        searchFilterVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:searchFilterVC animated:YES completion:nil];
    }
    else if ([segue.identifier isEqualToString:@"GoToLogin"])
    {
        BFLoginVC *vc = [segue destinationViewController];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:NO completion:nil];
    }
    else if ([segue.identifier isEqualToString:@"GoToUserMenu"])
    {
        BFUserVC *vc = [segue destinationViewController];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:NO completion:nil];
    }
    else if ([segue.identifier isEqualToString:@"GoToOrderMenu"])
    {
    }
    else if ([segue.identifier isEqualToString:@"GoToRecipesInfo"])
    {
        BFRecipesInfoVC *detailVC = [segue destinationViewController];
        BFRecipe *recipe = [self.recipeSets objectAtIndex:self.selectedIndex];
        [detailVC setRecipeInfo:recipe];
    }
    else if ([segue.identifier isEqualToString:@"GoToSellerInfo"])
    {
        BFSellerInfoVC *sellerVC = [segue destinationViewController];
        BFRecipe *recipe = [self.recipeSets objectAtIndex:self.selectedIndex];
//        [sellerVC setSellerInfo:recipe.recipeSeller];
    }
}

@end
