ios-audio-remote-control
========================

This repo demonstrates how to control the software based audio remote control in iOS.

I've seen a lot of confusion on the internet about where to set up the `removeControlEventRecievedWithEvent:` method and various approaches to the responder chain. I know this method works on iOS 6 and iOS 7. Other methods have not. Don't waste your time handling remote control events in the app delegate (where they used to work) or in a view controller which may go away during the lifecycle of your app.

Here's a quick rundown of what has to happen:

1. You need to create a subclass of UIApplication. In this subclass, you're going to implement the `remoteControlReceivedWithEvent:` and `canBecomeFirstResponder` methods. You want to return `YES` from `canBecomeFirstResponder`. In the remote control method, you'll probably want to notify your audio player that something's changed. 

2. You need to tell iOS to use your custom class to run the app, instead of the default `UIApplication`. To do so, open main.m and change this:

         return UIApplicationMain(argc, argv, nil, NSStringFromClass([RCAppDelegate class]));

   to look like this:

        return UIApplicationMain(argc, argv, NSStringFromClass([RCApplication class]), NSStringFromClass([RCAppDelegate class]));

   In my case `RCApplication` is the name of my custom class. Use the name of your subclass instead. Don't forget to `#import` the appropriate header.

3. OPTIONAL: You should configure an audio session. It's not required, but if you don't, audio won't play if the phone is muted.  I do this in the demo app's delegate, but do so where appropriate.

4. Play something. Until you do, the remote controls will ignore your app. I just took an `AVPlayer` and gave it the URL of a streaming site that I expect to be up. If you find that it fails, put your own URL in there and play with it to your heart's content.

This example has a little bit more code in there to log out remote events, but it's not all that complicated. I just define and pass around some string constants. 

Hope this helps someone out there!
