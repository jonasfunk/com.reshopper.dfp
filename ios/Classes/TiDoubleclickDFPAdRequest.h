/**
 * Ti.DoubleClick Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>
#import "TiProxy.h"
@import GoogleMobileAds;


@interface TiDoubleclickDFPAdRequest : NSObject {
@private
    DFPRequest* _request;
    NSMutableDictionary* _extras;
    BOOL extrasSet;
}

-(id)initWithProxy:(TiProxy*)proxy;
+(NSString*)setupAdUnitId:(TiProxy*)proxy;
+(GADAdSize)setupAdSize:(TiProxy*)proxy;
+(NSArray*)setupValidAdSizes:(TiProxy*)proxy;
-(void)setupCustomTargeting:(TiProxy*)proxy;
-(void)setupLocationTargeting:(TiProxy*)proxy;
-(void)setupAdColors:(TiProxy*)proxy;
-(GADRequest*)getRequestWithExtras;

@end
