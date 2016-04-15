//
//  BFUserVC.m
//  Biite
//
//  Created by JRRJ on 3/27/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFUserVC.h"
#import "BFMyUser.h"
#import "BFUser.h"
#import "BFAPI.h"
#import "BFWalletTableCell.h"
#import "BFFavoriteTableCell.h"
#import "BFNewFoodVC.h"


@interface BFUserVC () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UIView *userInfoView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIView *tableContentView;
@property (strong, nonatomic) IBOutlet UIView *buyerVideoView;

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userFullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *walletImageView;
@property (strong, nonatomic) IBOutlet UIButton *walletButton;
@property (strong, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UIImageView *sellFoodImageView;
@property (strong, nonatomic) IBOutlet UIButton *sellFoodButton;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL dismissesOnBackgroundTap;

@property (nonatomic) BOOL isSelectedWallet;
@property (nonatomic) BOOL isSelectedFavorite;

@property (strong, nonatomic) NSMutableArray *paymentSets;

@property (strong, nonatomic) NSArray *favoriteSets;
@property (strong, nonatomic) NSMutableArray *onlineSets;
@property (strong, nonatomic) NSMutableArray *offlineSets;

@end


@implementation BFUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.paymentSets = [[NSMutableArray alloc] init];
    [self loadPaymentMethods];
    
    self.favoriteSets = [[NSMutableArray alloc] init];
    self.onlineSets = [[NSMutableArray alloc] init];
    self.offlineSets = [[NSMutableArray alloc] init];
    [self loadFavorites];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BFWalletTableCell" bundle:nil] forCellReuseIdentifier:@"BFWalletTableCell"];
    
    self.userImageView.image = [BFMyUser sharedUser].profileImage;
    self.userFullNameLabel.text = [BFMyUser sharedUser].displayName;
    self.usernameLabel.text = [BFMyUser sharedUser].username;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchOverlayView:)];
    gestureRecognizer.delegate = self;
    [self.backView addGestureRecognizer:gestureRecognizer];
    
    _isSelectedWallet = false;
    _isSelectedFavorite = false;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.isSelectedWallet = false;
    self.dismissesOnBackgroundTap = true;
    
    self.walletImageView.image = [UIImage imageNamed:@"wallet_setting_img"];
    
    self.tableContentView.hidden = true;

    //    if (animated)
    {
        CGRect orign1 = self.userInfoView.frame;
        orign1.origin.y = -(self.userInfoView.frame.size.height + self.buttonView.frame.size.height + self.buyerVideoView.frame.size.height);
        self.userInfoView.frame = orign1;
        
        CGRect orign2 = self.buttonView.frame;
        orign2.origin.y = -(self.buttonView.frame.size.height + self.buyerVideoView.frame.size.height);
        self.buttonView.frame = orign2;
        
        CGRect orign3 = self.buyerVideoView.frame;
        orign3.origin.y = -self.buyerVideoView.frame.size.height;
        self.buyerVideoView.frame = orign3;
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect new1 = self.userInfoView.frame;
            new1.origin.y = 0;
            self.userInfoView.frame = new1;
            
            CGRect new2 = self.buttonView.frame;
            new2.origin.y = self.buttonView.frame.size.height;
            self.buttonView.frame = new2;
            
            CGRect new3 = self.buyerVideoView.frame;
            new3.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height;
            self.buyerVideoView.frame = new3;
        } completion:nil];
    }
}

- (void)dismissUserViewController
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
        
        CGRect new1 = self.userInfoView.frame;
        if (self.isSelectedWallet || self.isSelectedFavorite)
        {
            new1.origin.y = -(self.userInfoView.frame.size.height + self.buttonView.frame.size.height + self.tableContentView.frame.size.height + self.buyerVideoView.frame.size.height);
        }
        else
        {
            new1.origin.y = -(self.userInfoView.frame.size.height + self.buttonView.frame.size.height + self.buyerVideoView.frame.size.height);
        }
        self.userInfoView.frame = new1;
        
        CGRect new2 = self.buttonView.frame;
        if (self.isSelectedWallet || self.isSelectedFavorite)
        {
            new2.origin.y = -(self.buttonView.frame.size.height + self.tableContentView.frame.size.height + self.buyerVideoView.frame.size.height);
        }
        else
        {
            new2.origin.y = -(self.buttonView.frame.size.height + self.buyerVideoView.frame.size.height);
        }
        self.buttonView.frame = new2;
        
        CGRect new3 = self.tableContentView.frame;
        new3.origin.y = -(self.tableContentView.frame.size.height + self.buyerVideoView.frame.size.height);
        self.tableContentView.frame = new3;
        
        CGRect new4 = self.buyerVideoView.frame;
        new4.origin.y = -self.buyerVideoView.frame.size.height;
        self.buyerVideoView.frame = new3;
    } completion:^(BOOL finished)
     {
         [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
     }];
}

- (void)viewDidLayoutSubviews
{
    CGRect rect1 = self.buyerVideoView.frame;
    rect1.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height;
    self.buyerVideoView.frame = rect1;
    
    CGRect rect2 = self.tableContentView.frame;
    rect2.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height - self.tableContentView.frame.size.height;
    self.tableContentView.frame = rect2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickBack:(id)sender
{
    [BFMyUser logout];
    [self dismissUserViewController];
}

- (void)didTouchOverlayView:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.dismissesOnBackgroundTap)
    {
        [self dismissUserViewController];
    }
}

- (IBAction)onClickWallet:(id)sender
{
    if (!self.isSelectedWallet)
    {
        self.isSelectedWallet = true;
        self.dismissesOnBackgroundTap = false;
        
        self.walletImageView.image = [UIImage imageNamed:@"wallet_setting_sel_img"];
        
        [self.tableView registerNib:[UINib nibWithNibName:@"BFWalletTableCell" bundle:nil] forCellReuseIdentifier:@"BFWalletTableCell"];
        [self.tableView reloadData];
        
        [self showWallet];
    }
    else
    {
        self.isSelectedWallet = false;
        self.dismissesOnBackgroundTap = true;
        
        self.walletImageView.image = [UIImage imageNamed:@"wallet_setting_img"];
        
        [self hideWallet];
    }
}

- (void)showWallet
{
    if (self.isSelectedFavorite)
    {
        self.isSelectedFavorite = false;
        
        CGRect orign1 = self.tableContentView.frame;
        orign1.size.height = orign1.size.height - self.buyerVideoView.frame.size.height;
        orign1.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height - orign1.size.height;
        self.tableContentView.frame = orign1;
        
        CGRect orign2 = self.buyerVideoView.frame;
        orign2.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height;
        self.buyerVideoView.frame = orign2;
    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect new1 = self.tableContentView.frame;
        new1.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height;
        self.tableContentView.frame = new1;

        CGRect new2 = self.buyerVideoView.frame;
        new2.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height + self.tableContentView.frame.size.height;
        self.buyerVideoView.frame = new2;
        
    } completion:nil];
}

- (void)hideWallet
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect new1 = self.tableContentView.frame;
        new1.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height - self.tableContentView.frame.size.height;
        self.tableContentView.frame = new1;
        
        CGRect new2 = self.buyerVideoView.frame;
        new2.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height;
        self.buyerVideoView.frame = new2;
        
    } completion:nil];
}

- (IBAction)onClickFavorite:(id)sender
{
    if (!self.isSelectedFavorite)
    {
        self.isSelectedFavorite = true;
        self.dismissesOnBackgroundTap = false;
        
        self.favoriteImageView.image = [UIImage imageNamed:@"wallet_setting_sel_img"];
        
        [self.tableView registerNib:[UINib nibWithNibName:@"BFFavoriteTableCell" bundle:nil] forCellReuseIdentifier:@"BFFavoriteTableCell"];
        [self.tableView reloadData];
        
        [self showFavorites];
    }
    else
    {
        self.isSelectedWallet = false;
        self.dismissesOnBackgroundTap = true;
        
        self.favoriteImageView.image = [UIImage imageNamed:@"wallet_setting_img"];
        
        [self hideFavorites];
    }
}

- (void)showFavorites
{
    if (self.isSelectedWallet)
    {
        self.isSelectedWallet = false;
        
        CGRect orign1 = self.tableContentView.frame;
        orign1.size.height = orign1.size.height + self.buyerVideoView.frame.size.height;
        orign1.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height - orign1.size.height;
        self.tableContentView.frame = orign1;
        
        CGRect orign2 = self.buyerVideoView.frame;
        orign2.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height;
        self.buyerVideoView.frame = orign2;
    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect new1 = self.tableContentView.frame;
        new1.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height;
        self.tableContentView.frame = new1;
        
        CGRect new2 = self.buyerVideoView.frame;
        new2.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height + self.tableContentView.frame.size.height;
        self.buyerVideoView.frame = new2;
        
    } completion:nil];
}

- (void)hideFavorites
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect new1 = self.tableContentView.frame;
        new1.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height - self.tableContentView.frame.size.height;
        self.tableContentView.frame = new1;
        
        CGRect new2 = self.buyerVideoView.frame;
        new2.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height;
        self.buyerVideoView.frame = new2;
        
    } completion:nil];
    
    CGRect new3 = self.tableContentView.frame;
    new3.size.height = new3.size.height - self.buyerVideoView.frame.size.height;
    new3.origin.y = self.userInfoView.frame.size.height + self.buttonView.frame.size.height - new3.size.height;
    self.tableContentView.frame = new3;
}

- (IBAction)onClickSellFood:(id)sender
{
    [self performSegueWithIdentifier:@"GoToNewFood" sender:sender];
}

- (void)loadPaymentMethods
{
    [self.paymentSets addObject:@"Payment methods"];
    
//    for (NSDictionary *dict in self.buyer.buyerPayment)
//    {
//        [self.paymentSets addObject:dict];
//    }
    
    [self.paymentSets addObject:@{
                                  @"method":@"visa",
                                  @"title":@"*9009",
                                  @"enabled":@"Yes"
                                  }];
    [self.paymentSets addObject:@{
                                  @"method":@"visa",
                                  @"title":@"*9009",
                                  @"enabled":@"No"
                                  }];
    
    [self.paymentSets addObject:@"Add Payment methods"];
    [self.paymentSets addObject:@"Add credit card"];
    [self.paymentSets addObject:@"Add promo code"];
}

- (void)loadFavorites
{
    [self.onlineSets removeAllObjects];
    [self.offlineSets removeAllObjects];

    [BFAPI getFavoriteUsersWithCompletionHandler:^(NSError *error, id result)
    {
        for (NSDictionary *dict in result[@"user"])
        {
            BFUser *user = [BFUser userWithDictionary:dict];
            if (user.onlineStatus)
            {
                [self.onlineSets addObject:user];
            }
            else
            {
                [self.offlineSets addObject:user];
            }
        }
        
        self.favoriteSets = @[self.onlineSets, self.offlineSets];
    }];
}


#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isSelectedWallet)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSelectedWallet)
    {
        return [self.paymentSets count];
    }
    else
    {
        return  [self.favoriteSets[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSelectedWallet)
    {
        BFWalletTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BFWalletTableCell"];
        
        // Configure the cell...
        if (cell == nil)
        {
            cell = [[BFWalletTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BFWalletTableCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.methodsLabel.hidden = true;
        cell.paymentImageView.hidden = true;
        cell.paymentMethodLabel.hidden = true;
        cell.paymentMethodCheckImageView.hidden = true;
        cell.methodSelectImageView.hidden = true;
        cell.addMethodLabel.hidden = true;
        
        if (indexPath.row == 0 || indexPath.row == [self.paymentSets count] - 3)
        {
            cell.methodsLabel.text = [self.paymentSets objectAtIndex:indexPath.row];
            cell.methodsLabel.hidden = false;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else if (indexPath.row == [self.paymentSets count] - 2)
        {
            cell.paymentImageView.image = [UIImage imageNamed:@"add_credit_img"];
            cell.paymentImageView.hidden = false;
            cell.addMethodLabel.text = [self.paymentSets objectAtIndex:indexPath.row];
            cell.addMethodLabel.hidden = false;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else if (indexPath.row == [self.paymentSets count] - 1)
        {
            cell.paymentImageView.image = [UIImage imageNamed:@"add_promo_img"];
            cell.paymentImageView.hidden = false;
            cell.addMethodLabel.text = [self.paymentSets objectAtIndex:indexPath.row];
            cell.addMethodLabel.hidden = false;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else
        {
            NSDictionary *dict = [self.paymentSets objectAtIndex:indexPath.row];
            
            cell.paymentImageView.image = [UIImage imageNamed:@"visa_img"];
            cell.paymentImageView.hidden = false;
            cell.paymentMethodLabel.text = dict[@"title"];
            cell.paymentMethodLabel.hidden = false;
            
            if ([dict[@"enabled"] isEqualToString:@"Yes"])
            {
                cell.paymentMethodCheckImageView.hidden = false;
            }
            else
            {
                cell.paymentMethodCheckImageView.hidden = true;
            }
            
            cell.methodSelectImageView.hidden = false;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        
        return cell;
    }
    else
    {
        BFFavoriteTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BFFavoriteTableCell"];
        
        // Configure the cell...
        if (cell == nil)
        {
            cell = [[BFFavoriteTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BFFavoriteTableCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        BFUser *user = self.favoriteSets[indexPath.section][indexPath.row];
        
        cell.sellerDisplayName.text = user.displayName;
        
        if (indexPath.section == 0)
        {
            [cell.statusImageView setImage:[UIImage imageNamed:@"online_icon"]];
        }
        else
        {
            [cell.statusImageView setImage:[UIImage imageNamed:@"offline_icon"]];
        }
        
        NSString *str = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section+1,(long)indexPath.row];
        
        [user retrieveProfileImageWithCompletionHandler:^(NSError * error, UIImage *image, id key)
        {
            cell.sellerImageView.image = image;
        } andKey:str];
     
        return cell;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    if (self.isSelectedFavorite)
    {
        UIImageView *imageHeader = [UIImageView alloc] initWithImage:[UIImage imageNamed:@""]
        UILabel *labelHeader = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, headerView.frame.size.width-8, headerView.frame.size.height)];
        labelHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        labelHeader.textColor = [UIColor lightGrayColor];
        if (section==0)
        {
            labelHeader.text=@"Following";
        }
        else
        {
            labelHeader.text=@"Followers";
        }
        
        [headerView addSubview:labelHeader];
    }
    return headerView;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    CGFloat headerHeight = 30;
//    if (self.groupArray.count==1)
//    {
//        return 0;
//    }
//    else{
//        return  headerHeight;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSelectedWallet)
    {
        return 45;
    }
    else
    {
        return 89;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select ; %ld", (long)indexPath.row);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToNewFood"])
    {
//        BFNewFoodVC *vc = [segue destinationViewController];
//        [self presentViewController:vc animated:YES completion:nil];
    }
}


@end
