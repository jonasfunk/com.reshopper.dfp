/**
 * Ti.DoubleClick Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiDoubleclickDFPAdRequest.h"
#import "TiApp.h"
#import "TiUtils.h"
#import "TiProxy.h"

@import GoogleMobileAds;

@implementation TiDoubleclickDFPAdRequest

DEFINE_EXCEPTIONS

-(id)init
{
    if (self = [super init]) {
        _request = [[DFPRequest alloc] init];
        _extras = [[NSMutableDictionary alloc] init];
        extrasSet = NO;
    }

    return self;
}

-(id)initWithProxy:(TiProxy*)proxy
{
    if (self = [super init]) {
        [self setupCustomTargeting:proxy];
        [self setupLocationTargeting:proxy];
        [self setupAdColors:proxy];
    }
    
    return self;
}

-(void)dealloc
{
    RELEASE_TO_NIL(_extras);
    RELEASE_TO_NIL(_request);
    
    [super dealloc];
}

-(DFPRequest*)getRequestWithExtras
{
    // Return a request object ready for setting in DoubleClick. To do this we take the extras object and add
    // it to the request object.
    if (!extrasSet) {
        GADExtras* extras = [[[GADExtras alloc] init] autorelease];
        extras.additionalParameters = _extras;
        [_request registerAdNetworkExtras:extras];
        extrasSet = YES;
    }
    return _request;
}

+(GADAdSize)convertValidAdSize:(id)arg
{
    if ([arg isKindOfClass:[NSDictionary class]]) {
        BOOL exists;
        id width = [NSNumber numberWithInt:(int)[TiUtils intValue:@"width" properties:arg def:0 exists:&exists]];
        if (exists) {
            id height = [NSNumber numberWithInt:(int)[TiUtils intValue:@"height" properties:arg def:0 exists:&exists]];
            if (exists) {
                return GADAdSizeFromCGSize(CGSizeMake([width integerValue],[height integerValue]));
            }
        }
    }

    THROW_INVALID_ARG(@"adSize dictionary must contain 'width' and 'height' properties");
    
    return kGADAdSizeBanner;
}

+(NSString*)setupAdUnitId:(TiProxy*)proxy
{
    NSString* adUnitID = [proxy valueForKey:@"adUnitId"];
    if (adUnitID != nil) {
        return adUnitID;
    }
    
    THROW_INVALID_ARG(@"adUnitID is required");
}

+(GADAdSize)setupAdSize:(TiProxy*)proxy
{
    id obj = [proxy valueForKey:@"adSize"];
    if (obj != nil) {
        return [self convertValidAdSize:obj];
    }
    
    NSLog(@"[INFO] adSize not specified -- using default banner size");
    
    return kGADAdSizeBanner;
}

+(NSArray*)setupValidAdSizes:(TiProxy*)proxy
{
    id obj = [proxy valueForKey:@"validAdSizes"];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray* validAdSizes = [NSMutableArray arrayWithCapacity:[obj count]];
        for (id item in (NSArray*)obj) {
            GADAdSize adSize = [self convertValidAdSize:item];
            [validAdSizes addObject:[NSValue valueWithBytes:&adSize objCType:@encode(GADAdSize)]];
        }
        return validAdSizes;
    } else if (obj != nil){
        THROW_INVALID_ARG(@"adSize must be an array of dictionary entries that contain 'width' and 'height' properties");
    }
    
    return nil;
}

-(void)setupCustomTargeting:(TiProxy*)proxy
{
    id obj = [proxy valueForKey:@"customTargeting"];
    if (obj != nil) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [_extras addEntriesFromDictionary:obj];
        } else {
            THROW_INVALID_ARG(@"customTargeting must be a dictionary of key-value pairs");
        }
    }
}

-(void)setupLocationTargeting:(TiProxy*)proxy
{
    id obj = [proxy valueForKey:@"location"];
    if (obj != nil) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [_request setLocationWithLatitude:[[obj valueForKey:@"latitude"] floatValue]
                                    longitude:[[obj valueForKey:@"longitude"] floatValue]
                                     accuracy:[[obj valueForKey:@"accuracy"] floatValue]];
        } else {
            THROW_INVALID_ARG(@"location must be a dictionary containing 'longitude', 'latitude', and 'accuracy' properties");
        }
    }
}

-(void)setupAdColors:(TiProxy*)proxy
{
    id obj = [proxy valueForKey:@"adColors"];
    if (obj != nil) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            for (id key in obj) {
                [_extras setObject:[self convertColor:[obj valueForKey:key]] forKey:key];
            }
        } else {
            THROW_INVALID_ARG(@"adColors must be a dictionary of color properties");
        }
    }
}

-(NSString*)convertColor:(NSString*)color
{
    color = [color stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([color isEqualToString:@"white"]) {
        color = @"FFFFFF";
    } else if ([color isEqualToString:@"red"]) {
        color = @"FF0000";
    } else if ([color isEqualToString:@"blue"]) {
        color = @"0000FF";
    } else if ([color isEqualToString:@"green"]) {
        color = @"008000";
    } else if ([color isEqualToString:@"yellow"]) {
        color = @"FFFF00";
    } else if ([color isEqualToString:@"black"]) {
        color = @"000000";
    }

    return color;
}

@end
