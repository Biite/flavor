//
//  BFOrderMenuVC.m
//  Biite
//
//  Created by JRRJ on 3/27/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFOrderMenuVC.h"
#import "BFOrderMenuTableCell.h"
#import "BFRecipe.h"

@interface BFOrderMenuVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *checkoutButton;

@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (strong, nonatomic) NSMutableArray *orderedSets;
@property (strong, nonatomic) NSMutableDictionary *indexSets;

@end


@implementation BFOrderMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGSize frameSize = self.view.frame.size;
    self.preferredContentSize = CGSizeMake(frameSize.width, frameSize.height);
    
    self.checkoutButton.hidden = true;
    
    self.orderedSets = [[NSMutableArray alloc] init];
    [self getOrders];
    
    self.indexSets = [[NSMutableDictionary alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.checkoutButton.hidden = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickBack:(id)sender
{
    self.checkoutButton.hidden = true;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)getOrders
{
    // API call
    NSArray *result = @[@{
                            @"name": @"Paella Valenciana",
                            //                             @"imageURL": @"http://cloudniary.com/a.jpg",
                            @"imageURL": @"sample_recipe_img0",
                            @"price": @"$25",
                            @"seller": @"Ricardo",
                            @"serves": @"2",
                            @"orderMode": @"TAKE OUT",
                        },
                        @{
                            @"name": @"Paella Valenciana",
                            //                             @"imageURL": @"http://cloudniary.com/a.jpg",
                            @"imageURL": @"sample_recipe_img0",
                            @"price": @"$25",
                            @"seller": @"Ricardo",
                            @"serves": @"2",
                            @"orderMode": @"TAKE OUT",
                        }
                    ];
    
    // recipeSets
    for (NSDictionary *dict in result)
    {
        [self.orderedSets addObject:dict];
    }
    
    [self calcAllPrice];
}

- (void)calcAllPrice
{
    NSInteger totalPrice = 0;
    for (NSDictionary *dict in self.orderedSets)
    {
        NSInteger price = [dict[@"price"] substringWithRange:NSMakeRange(1, [dict[@"price"] length] - 1)].integerValue;
        totalPrice = totalPrice + price;
    }
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"$%ld", (long)totalPrice];
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderedSets count];
}

- (BFOrderMenuTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BFOrderMenuTableCell";
    BFOrderMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[BFOrderMenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dict = [self.orderedSets objectAtIndex:indexPath.row];
    
    cell.recipeName.text = dict[@"name"];
    cell.seller.text = [NSString stringWithFormat:@"by %@", dict[@"seller"]];
    cell.servesCount.text = [NSString stringWithFormat:@"Serves %@ people", dict[@"serves"]];

    if ([dict[@"orderMode"] isEqualToString:@"TAKE OUT"])
    {
        cell.orderModeImageView.image = [UIImage imageNamed:@"takeout_sel_img"];
        cell.orderModeLabel.text = dict[@"orderMode"];
    }
    else if ([dict[@"orderMode"] isEqualToString:@"EAT THERE"])
    {
        
    }
    
    cell.recipePriceLabel.text = dict[@"price"];
    
    [cell.removeButton addTarget:self action:@selector(removeItem:) forControlEvents:UIControlEventTouchUpInside];
    cell.removeButton.tag = indexPath.row;
//    [self.indexSets setObject:indexPath forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
//    NSString *recipeImageURL = dict[@"imageURL"];
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
    cell.recipeImageView.image = [UIImage imageNamed:dict[@"imageURL"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}


- (void)removeItem:(UIButton *)sender
{
    NSInteger row = sender.tag;
    [self.orderedSets removeObjectAtIndex:row];
    
    [self calcAllPrice];
    [self.tableView reloadData];
//    
//    NSIndexPath *indexPath = [self.indexSets objectForKey:[NSString stringWithFormat:@"%ld", (long)row]];
//    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
