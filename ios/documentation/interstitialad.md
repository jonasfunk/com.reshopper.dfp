# Ti.DoubleClick.InterstitialAd

## Description

A DoubleClick Interstitial ad is created by the method [Ti.DoubleClick.createInterstitialAd][].

Before calling this method, create an ad unit in DFP to represent the interstitial ad unit. Interstitial ad units can
be defined with one of the four common sizes, regardless of the actual screen size of individual devices. The SDK will
handle rendering the creative correctly on screens which are of slightly different sizes.

## Functions

### presentAd

Displays the full-screen ad. This function is called automatically by the module when the ad is ready if the
`presentAd` property is set to `true`. Otherwise, it can be called by the application after receiving the
`didReceiveAd` event.

## Properties

### adUnitId[adUnitId]

The ad's DFP ad unit ID (Required)

### testing[boolean]

Whether or not DoubleClick should be run in testing mode. Running in testing mode returns
test ads to the simulator when running in simulator, and the current device when running
from device. Default is `false`.

### presentAd[boolean]

An optional flag to control when the ad is displayed. If this flag is `true` then the ad will be automatically
displayed when it has finished downloading. If this flag is `false` then the ad will not be displayed until
the `presentAd` method is called. Default is `true`.

### isReady[boolean]

Indicates if the ad is ready for display.

## Events

### didReceiveAd

Sent when an ad request loaded an ad.

### didFailToReceiveAd

Sent when an ad request failed. Normally this is because no network connection was available or no ads were available (i.e. no fill).

#### Properties

* error[string] - error message

### willPresentScreen

Sent just before presenting the user a full screen view, such as a browser, in response to clicking on an ad. Use this
opportunity to stop animations, time sensitive interactions, etc.

Normally the user looks at the ad, dismisses it, and control returns to your application by firing off "didDismissScreen".
However if the user hits the Home button or clicks on an App Store link your application may end.
In that case, "willLeaveApplication" would fire.

### willDismissScreen

Sent just before dismissing a full screen view.

### didDismissScreen

Sent just after dismissing a full screen view. Use this opportunity to restart anything you may have stopped as part of "willPresentScreen".

### willLeaveApplication

Sent just before the application will background or terminate because the user clicked on an ad that will launch another application (such as the App Store).

[Ti.DoubleClick.createInterstitialAd]: index.html