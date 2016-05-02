//
//  WebMoment.h
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2016-04-29.
//  Copyright © 2016 Flybits Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// Tutorial Section 4.6a (Moments) - Helper Classes
@interface WebData : NSObject

#pragma mark - Properties
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *summary;
@property (nonatomic) NSString *URLString;
@property (nonatomic) NSString *locale;
@property (nonatomic) NSURL *URL;

#pragma mark - Lifecycle Functions
- (instancetype)initWithLocale:(NSString *)locale andDictionary:(NSDictionary *)dictionary;

@end


@interface WebMomentData : NSObject

#pragma mark - Properties
@property (nonatomic) NSMutableArray<WebData *> *websites;

#pragma mark - Lifecycle Functions
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
