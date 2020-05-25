# Ti.DoubleClick.BannerAdView

## Description

A view for displaying ads delivered from DoubleClick for Publishers.
A DoubleClick BannerAdView is created by the method [Ti.DoubleClick.createBannerAdView][].
It provides access to Google's DoubleClick for Publishers advertising services.

## Properties

### adUnitId[adUnitId]

The ad's DFP ad unit ID (Required)

### adSize[object]

A optional dictionary of key-values specifying the size of the ad to display. If no value is specified then
the default banner size is used.

* width[int] - the width of the ad (Required)
* height[int] - the height of the ad (Required)

### testing[boolean]

Whether or not DoubleClick should be run in testing mode. Running in testing mode returns
test ads to the simulator when running in simulator. Default is `false`.

### validAdSizes[array]

An optional array of ad sizes (Dictionary entries) that specifies multiple ad sizes which may be
served. Before using this property you must create a line item targeting the same ad unit id
that is associated with different size creatives. Each entry in the array is a dictionary
of key-values specifying the size of the ad to display.

* width[int] - the width of the ad (Required)
* height[int] - the height of the ad (Required)

### customTargeting[object]

An optional dictionary of key-values used to target DFP campaigns. Out of respect for user privacy,
Google asks that you only specify location and demographic data if that information is already
used by your app.

### location[object]

An optional dictionary with the location of the user for location-based ads.

* latitude[float] - the latitude of the user
* longitude[float] - the longitude of the user
* accuracy[float] - accuracy of the location data

### Ti.DoubleClick.View.width[double]

The width of the container your ad will be placed in.

### Ti.DoubleClick.View.height[double]

The height of the container your ad will be placed in.

## Events

### appEvent

Sent by DoubleClick for Publishers for specific events.

#### Properties

The specify property name and value are contained in the event object.

### willChangeAdSizeTo

Sent when the size of the ad is changed (applicable when using multiple ad sizes via the `validAdSizes` property).

#### Properties

* oldWidth[int] - the previous width of the ad
* oldHeight[int] - the previous height of the ad
* newWidth[int] - the new width of the ad
* newHeight[int] - the new height of the ad

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

[Ti.DoubleClick.createBannerAdView]: index.html