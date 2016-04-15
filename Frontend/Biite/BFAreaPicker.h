//
//  BFAreaPicker.h
//  Biite
//
//  Created by JRRJ on 3/15/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BFAreaPicker;

@protocol BFAreaPickerDelegate <UIPickerViewDelegate>

- (void)countryPicker:(BFAreaPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code;

@end


@interface BFAreaPicker : UIPickerView

+ (NSArray *)countryNames;
+ (NSArray *)countryCodes;
+ (NSDictionary *)countryNamesByCode;
+ (NSDictionary *)countryCodesByName;

@property (nonatomic, weak) id<BFAreaPickerDelegate> delegate;

@property (nonatomic, strong) NSString *selectedCountryName;
@property (nonatomic, strong) NSString *selectedCountryCode;
@property (nonatomic, strong) NSLocale *selectedLocale;

- (void)setSelectedCountryCode:(NSString *)countryCode animated:(BOOL)animated;
- (void)setSelectedCountryName:(NSString *)countryName animated:(BOOL)animated;
- (void)setSelectedLocale:(NSLocale *)locale animated:(BOOL)animated;

@end
