//
//  MomentViewController.m
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2016-04-28.
//  Copyright © 2016 Flybits Inc. All rights reserved.
//

#import "TextMoment.h"
#import "WebMoment.h"
#import "MomentViewController.h"

@interface MomentViewController ()

#pragma mark - IBOutlets
@property (nonatomic) IBOutlet UIWebView *momentWebView;
@property (nonatomic) IBOutlet UITextView *momentTextView;

@end

@implementation MomentViewController

const NSString * const URL = @"url";
// Tutorial Section 4.6 (Moments)

// Tutorial Section 4.1b (Moments)

#pragma mark - Lifecycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    // Tutorial Seciton 4.4 (Moments)
    [self setTitle:@"Moment"];
}

#pragma mark - Functions
// Tutorial Section 4.5 (Moments)

@end
