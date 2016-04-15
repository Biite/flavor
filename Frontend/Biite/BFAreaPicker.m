//
//  BFAreaPicker.m
//  Biite
//
//  Created by JRRJ on 3/15/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFAreaPicker.h"


@interface BFAreaPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@end


@implementation BFAreaPicker

//doesn't use _ prefix to avoid name clash with superclass
@synthesize delegate;

+ (NSArray *)countryNames
{
    static NSArray *_countryNames = nil;
    if (!_countryNames)
    {
        _countryNames = [[[[self countryNamesByCode] allValues] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] copy];
    }
//    _countryNames = @[@"AFRICAN",@"AMERICAN", @"EUROPEAN", @"MEDITERRANEAN", @"MIDDLE EASTERN", @"JAPANESE"];
    
    return _countryNames;
}

+ (NSArray *)countryCodes
{
    static NSArray *_countryCodes = nil;
    if (!_countryCodes)
    {
        _countryCodes = [[[self countryCodesByName] objectsForKeys:[self countryNames] notFoundMarker:@""] copy];
    }
    return _countryCodes;
}

+ (NSDictionary *)countryNamesByCode
{
    static NSDictionary *_countryNamesByCode = nil;
    if (!_countryNamesByCode)
    {
        NSMutableDictionary *namesByCode = [NSMutableDictionary dictionary];
        for (NSString *code in [NSLocale ISOCountryCodes])
        {
            NSString *countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:code];
            
            //workaround for simulator bug
            if (!countryName)
            {
                countryName = [[NSLocale localeWithLocaleIdentifier:@"en_US"] displayNameForKey:NSLocaleCountryCode value:code];
            }
            
            namesByCode[code] = countryName ?: code;
        }
        _countryNamesByCode = [namesByCode copy];
    }
    return _countryNamesByCode;
}

+ (NSDictionary *)countryCodesByName
{
    static NSDictionary *_countryCodesByName = nil;
    if (!_countryCodesByName)
    {
        NSDictionary *countryNamesByCode = [self countryNamesByCode];
        NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
        for (NSString *code in countryNamesByCode)
        {
            codesByName[countryNamesByCode[code]] = code;
        }
        _countryCodesByName = [codesByName copy];
    }
    return _countryCodesByName;
}

- (void)setUp
{
    super.dataSource = self;
    super.delegate = self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)setSelectedCountryCode:(NSString *)countryCode animated:(BOOL)animated
{
    NSUInteger index = [[[self class] countryCodes] indexOfObject:countryCode];
    if (index != NSNotFound)
    {
        [self selectRow:(NSInteger)index inComponent:0 animated:animated];
    }
}

- (void)setSelectedCountryCode:(NSString *)countryCode
{
    [self setSelectedCountryCode:countryCode animated:NO];
}

- (NSString *)selectedCountryCode
{
    NSUInteger index = (NSUInteger)[self selectedRowInComponent:0];
    return [[self class] countryCodes][index];
}

- (void)setSelectedCountryName:(NSString *)countryName animated:(BOOL)animated
{
    NSUInteger index = [[[self class] countryNames] indexOfObject:countryName];
    if (index != NSNotFound)
    {
        [self selectRow:(NSInteger)index inComponent:0 animated:animated];
    }
}

- (void)setSelectedCountryName:(NSString *)countryName
{
    [self setSelectedCountryName:countryName animated:NO];
}

- (NSString *)selectedCountryName
{
    NSUInteger index = (NSUInteger)[self selectedRowInComponent:0];
    return [[self class] countryNames][index];
}

- (void)setSelectedLocale:(NSLocale *)locale animated:(BOOL)animated
{
    [self setSelectedCountryCode:[locale objectForKey:NSLocaleCountryCode] animated:animated];
}

- (void)setSelectedLocale:(NSLocale *)locale
{
    [self setSelectedLocale:locale animated:NO];
}

- (NSLocale *)selectedLocale
{
    NSString *countryCode = self.selectedCountryCode;
    if (countryCode)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents:@{NSLocaleCountryCode: countryCode}];
        return [NSLocale localeWithLocaleIdentifier:identifier];
    }
    return nil;
}


#pragma mark -
#pragma mark UIPicker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (NSInteger)[[[self class] countryCodes] count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 90)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, 170, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [label setFont:[UIFont boldSystemFontOfSize:17]];
        label.tag = 1;
        [view addSubview:label];
        
        UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 37, 16, 16)];
        flagView.contentMode = UIViewContentModeScaleAspectFit;
        flagView.tag = 2;
        [view addSubview:flagView];
    }
    
    ((UILabel *)[view viewWithTag:1]).text = [[self class] countryNames][(NSUInteger)row];
    
    if ([self selectedRowInComponent:0] == row)
    {
        ((UIImageView *)[view viewWithTag:2]).image = [UIImage imageNamed:@"country_sel_img"];
    }
    else
    {
        ((UIImageView *)[view viewWithTag:2]).image = [UIImage imageNamed:@"country_desel_img"];
    }
    
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:( NSInteger)row
       inComponent:( NSInteger)component
{
    id<BFAreaPickerDelegate> strongDelegate = delegate;
    [strongDelegate countryPicker:self didSelectCountryWithName:self.selectedCountryName code:self.selectedCountryCode];

    [self reloadAllComponents];
}

@end
