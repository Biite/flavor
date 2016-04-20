//
//  BFSellerInfoVC.m
//  Biite
//
//  Created by JRRJ on 3/11/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFSellerInfoVC.h"
#import "BFRecipesListCollectionCell.h"
#import "BFAPI.h"
#import "BFRecipeDetailVC.h"
#import "BFRecipe.h"
#import "BFShareMenuVC.h"
#import "UIImage+ImageUtils.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SVProgressHUD.h>


@interface BFSellerInfoVC () <UICollectionViewDataSource, UICollectionViewDelegate,  UIImagePickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UINavigationControllerDelegate>

@property (strong, atomic) NSMutableArray *recipeSets;
@property (nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UITextView *biographyTextView;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (strong, nonatomic) IBOutlet UILabel *reviewsLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *recipesCollectionView;

@end


@implementation BFSellerInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameLabel.text = self.sellerInfo.displayName;
    self.biographyTextView.text = self.sellerInfo.biography;

    self.profileImageView.image = self.sellerInfo.profileImage;
//    [self.sellerInfo retrieveProfileImageWithCompletionHandler:^(NSError *error, UIImage *image, id result) {
//        self.profileImageView.image = image;
//    } andKey:nil];

    self.coverImageView.image = self.sellerInfo.coverImage;
//    [self.sellerInfo retrieveCoverImageWithCompletionHandler:^(NSError *error, UIImage *image, id result) {
//        self.coverImageView.image = image;
//    } andKey:nil];
    
    self.recipeSets = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getRecipes];
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

- (void)getRecipes
{
    [SVProgressHUD show];
    
    [self.recipeSets removeAllObjects];
    
    [BFAPI getSellerRecipes:self.sellerInfo.userID withCompletionHandler:^(NSError *error, id result)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            
            if (!error)
            {
                for (NSDictionary *dict in result[@"posts"])
                {
                    BFRecipe *recipe = [BFRecipe recipeWithDictionary:dict];
                    [self.recipeSets addObject:recipe];
                }
                
                [self.recipesCollectionView reloadData];
            }
            else
            {
                
            }
        });        
    }];
}

- (IBAction)onClickAddToFavs:(id)sender
{
    [SVProgressHUD show];
    
    [BFAPI addFavoriteUser:self.sellerInfo.userID withCompletionHandler:^(NSError *error, id result)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            
            if (!error)
            {
            }
            else
            {                
            }
        });
    }];
}

- (IBAction)onClickContact:(id)sender
{
}

- (IBAction)onClickTakeProfileBackground:(id)sender
{
    if ([UIAlertController class])
    {
        // iOS 8.3 later
        UIAlertController *photoAction = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action)
                                          {
                                              [self takePhoto:nil];
                                          }];
        
        UIAlertAction *selectPhotoAction =[UIAlertAction actionWithTitle:@"Choose Existing"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action)
                                           {
                                               [self selectPhoto:nil];
                                           }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) { }];
        
        [photoAction addAction:takePhotoAction];
        [photoAction addAction:selectPhotoAction];
        [photoAction addAction:cancelAction];
        
        [self presentViewController:photoAction animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
        
        [actionSheet showInView:self.view];
    }
}


#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = info[UIImagePickerControllerEditedImage];
    
    self.coverImageView.image = [UIImage imageWithImage:img scaledToSize:CGSizeMake(self.coverImageView.frame.size.width, self.coverImageView.frame.size.height)];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self takePhoto:nil];
            break;
            
        case 1:
            [self selectPhoto:nil];
            break;
    }
}

- (void)takePhoto:(UIButton *)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"No Camera Available");
    }
}

- (void)selectPhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - UICollectionView Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return [self.recipeSets count];
}

-(BFRecipesListCollectionCell *)collectionView:(UICollectionView *)collectionView
                cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BFRecipesListCollectionCell";
    BFRecipesListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    BFRecipe *recipe = self.recipeSets[indexPath.row];
    
    cell.recipeNameLabel.text = recipe.recipeName;
    cell.priceLabel.text = recipe.price;
    
    cell.recipeButton.tag = indexPath.row;
    [cell.recipeButton addTarget:self action:@selector(displayRecipeDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.recipeImageView.image = recipe.image;
//    NSString *recipeImageURL = recipe.imageURL;
//    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:recipeImageURL]
//                                                    options:SDWebImageRefreshCached
//                                                   progress:nil
//                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
//     {
//         if (image != NULL)
//         {
//             cell.recipeImageView.image = image;
//         }
//     }];
    
    return cell;
}

- (void)displayRecipeDetail:(id)sender
{
    UIButton *selected = (UIButton *)sender;
    self.selectedIndex = selected.tag;
    [self performSegueWithIdentifier:@"GoToRecipeDetail" sender:sender];
}


#pragma mark - UICollectionViewDelegate
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.selectedIndex = indexPath.row;
//    [self performSegueWithIdentifier:@"GoToRecipeDetail" sender:nil];
//}


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
        BFRecipe *info = self.recipeSets[self.selectedIndex];
        [detailVC setRecipeInfo:info];
    }
}

@end
