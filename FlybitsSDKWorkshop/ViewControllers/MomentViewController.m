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
- (void)setMoment:(Moment *)moment {
    _moment = moment;
    
    self.title = [moment momentName] ? [moment momentName] : @"Moment";
}

#pragma mark - Lifecycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    // Tutorial Seciton 4.4 (Moments)
    if(_moment != nil) {
        self.title = [_moment momentName] ? [_moment momentName] : @"Moment";
        
        [APIManager momentAutoValidate:_moment completion:^(BOOL validated, NSError * _Nullable error) {
            if(validated) {
                [self loadMomentData];
            } else {
                NSLog(@"Encountered validation error: %@", [error localizedDescription]);
            }
        }];
    } else {
        [self setTitle:@"Moment"];
    }
}

#pragma mark - Functions
// Tutorial Section 4.5 (Moments)
- (void)loadMomentData {
    NSString *urlString = [NSString stringWithFormat:@"%@/WebsiteBits?alllocales=true", [_moment launchURL]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil || data == nil) {
            NSLog(@"Encountered error: %@", error);
            return;
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(error != nil) {
            NSLog(@"Encountered error: %@", [error localizedDescription]);
            return;
        }
        
        [_momentWebView setHidden:NO];
        [_momentTextView setHidden:YES];
        
        WebMomentData *webMomentData = [[WebMomentData alloc] initWithDictionary:json];
        NSURL *url = [[[webMomentData websites] firstObject] URL];
        if(url != nil) {
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_momentWebView loadRequest:webRequest];
            });
        }
    }];
    
    // Issue request
    [task resume];
}

@end
