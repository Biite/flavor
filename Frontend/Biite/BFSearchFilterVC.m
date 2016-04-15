//
//  BFSearchFilterVC.m
//  Biite
//
//  Created by JRRJ on 3/14/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFSearchFilterVC.h"
#import "BFRangeSlider.h"
#import "BFAreaPicker.h"


@interface BFSearchFilterVC () <BFAreaPickerDelegate>

@property (strong, nonatomic) IBOutlet UIView *distanceSliderView;
@property (strong, nonatomic) IBOutlet BFRangeSlider *distanceSlider;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@property (strong, nonatomic) IBOutlet UIView *takeOutView;
@property (strong, nonatomic) IBOutlet UIView *deliveryView;
@property (strong, nonatomic) IBOutlet UIView *cookHereView;
@property (strong, nonatomic) IBOutlet UIView *eatThereView;

@property (nonatomic, strong) UIColor *selectedBtnColor;
@property (nonatomic, strong) UIColor *deselectedBtnColor;

@property (strong, nonatomic) IBOutlet UIView *priceSliderView;
@property (strong, nonatomic) IBOutlet BFRangeSlider *priceSlider;
@property (strong, nonatomic) IBOutlet UILabel *priceLowerLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceUpperLabel;

@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet BFAreaPicker *picker;

@property (strong, nonatomic) IBOutlet UIImageView *saveBtnBorder;
@property (strong, nonatomic) IBOutlet UILabel *saveBtnLabel;

@property (strong, nonatomic) IBOutlet UIImageView *resetBtnBorder;
@property (strong, nonatomic) IBOutlet UILabel *resetBtnLabel;

@end


@implementation BFSearchFilterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.takeOutView.layer.cornerRadius = 5.0;
    self.deliveryView.layer.cornerRadius = 5.0;
    self.cookHereView.layer.cornerRadius = 5.0;
    self.eatThereView.layer.cornerRadius = 5.0;
    
    self.selectedBtnColor = [UIColor colorWithRed:122.0/255.0 green:189.0/255.0 blue:63.0/255.0 alpha:1.0];
    self.deselectedBtnColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    [self loadFilterSettings];
    
    self.distanceLabel.hidden = true;
    [self configureDistanceSlider];
    
    self.priceLowerLabel.hidden = true;
    self.priceUpperLabel.hidden = true;
    [self configurePriceSlider];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateDistanceSlider];
    self.distanceLabel.hidden = false;
    
    [self updatePriceSlider];
    self.priceLowerLabel.hidden = false;
    self.priceUpperLabel.hidden = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFilterSettings
{
    
}

- (IBAction)onClickBtnTakeOut:(id)sender
{
    self.takeOutView.backgroundColor = self.selectedBtnColor;
    self.deliveryView.backgroundColor = self.deselectedBtnColor;
    self.cookHereView.backgroundColor = self.deselectedBtnColor;
    self.eatThereView.backgroundColor = self.deselectedBtnColor;
    
    // process
}

- (IBAction)onClickBtnDelivery:(id)sender
{
    self.takeOutView.backgroundColor = self.deselectedBtnColor;
    self.deliveryView.backgroundColor = self.selectedBtnColor;
    self.cookHereView.backgroundColor = self.deselectedBtnColor;
    self.eatThereView.backgroundColor = self.deselectedBtnColor;
    
    // process
}

- (IBAction)onClickBtnCookHere:(id)sender
{
    self.takeOutView.backgroundColor = self.deselectedBtnColor;
    self.deliveryView.backgroundColor = self.deselectedBtnColor;
    self.cookHereView.backgroundColor = self.selectedBtnColor;
    self.eatThereView.backgroundColor = self.deselectedBtnColor;
    
    // process
}

- (IBAction)onClickBtnEatThere:(id)sender
{
    self.takeOutView.backgroundColor = self.deselectedBtnColor;
    self.deliveryView.backgroundColor = self.deselectedBtnColor;
    self.cookHereView.backgroundColor = self.deselectedBtnColor;
    self.eatThereView.backgroundColor = self.selectedBtnColor;
    
    // process
}

- (IBAction)onClickBtnSave:(id)sender
{
    // save process
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickBtnReset:(id)sender
{
    // reset process
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) configureDistanceSlider
{
    [self.distanceSlider setLowerHandleHidden:true];

    self.distanceSlider.maximumValue = 99;
    
    self.distanceSlider.upperValue = 55;
    
    self.distanceSlider.minimumRange = 1;
}

- (void) updateDistanceSlider
{
    // You get get the center point of the slider handles and use this to arrange other subviews

    CGPoint upperCenter;
    upperCenter.x = (self.distanceSlider.upperCenter.x + self.distanceSlider.frame.origin.x);
    upperCenter.y = self.distanceSlider.center.y;
    self.distanceLabel.center = upperCenter;
    self.distanceLabel.text = [NSString stringWithFormat:@"%d", (int)self.distanceSlider.upperValue];
}

// Handle control value changed events just like a normal slider
- (IBAction)distanceSliderChanged:(BFRangeSlider*)sender
{
    [self updateDistanceSlider];
}

- (void) configurePriceSlider
{
    self.priceSlider.minimumValue = 1;
    self.priceSlider.maximumValue = 99;
    
    self.priceSlider.lowerValue = 25;
    self.priceSlider.upperValue = 55;
    
    self.priceSlider.minimumRange = 10;
}

- (void) updatePriceSlider
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.priceSlider.lowerCenter.x + self.priceSlider.frame.origin.x);
    lowerCenter.y = self.priceSlider.center.y;
    self.priceLowerLabel.center = lowerCenter;
    self.priceLowerLabel.text = [NSString stringWithFormat:@"$%d", (int)self.priceSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.priceSlider.upperCenter.x + self.priceSlider.frame.origin.x);
    upperCenter.y = self.priceSlider.center.y;
    self.priceUpperLabel.center = upperCenter;
    self.priceUpperLabel.text = [NSString stringWithFormat:@"$%d", (int)self.priceSlider.upperValue];
}

// Handle control value changed events just like a normal slider
- (IBAction)priceSliderChanged:(BFRangeSlider*)sender
{
    [self updatePriceSlider];
}

- (void)countryPicker:(BFAreaPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code
{
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
