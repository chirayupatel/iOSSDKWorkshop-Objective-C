//
//  TextMomentData.h
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2016-04-29.
//  Copyright © 2016 Flybits Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextData : NSObject

#pragma mark - Properties

@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *summary;

#pragma mark - Lifecycle Functions

- (instancetype)initWithIdentifier:(NSInteger)identifier andDictionary:(NSDictionary *)dictionary;

@end

@interface TextMomentData : NSObject

#pragma mark - Properties

@property (nonatomic) NSMutableDictionary<NSObject *, TextData *> *texts;

#pragma mark - Lifecycle Functions

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
