/**
 * Ti.DoubleClick Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiUIView.h"
#import "TiDoubleclickDFPAdRequest.h"
@import GoogleMobileAds;

@interface TiDoubleclickBannerAdView : TiUIView
    <GADAdSizeDelegate,GADBannerViewDelegate,GADAppEventDelegate> {
    DFPBannerView *_ad;
         BOOL _adRequested;
       
}



@end
