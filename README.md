# winkwink - nudge the world back to health

This is my [hackthecrisis 2020](https://www.hackthecrisis.se/) submission in the "Save lives" category.

## Problem description
It can be hard to take in all the advice and restrictions from government agencies and experts
in light of the COVID-19 crisis, and turn it into practice. We all need to change our behaviors, and sometimes that means we
have to change deeply ingrained habits.

## Solution
'wink wink' is a mobile app that will nudge you with notifications during the day to encourage and
remind you to behave according to official recommendations.

You can select which nudges you want to enable, and will get notification texts relating to
that topic during the day.

![winkwink in action](winkwink.gif)

## Technical details
A [Flutter](https://flutter.dev/) Android application using some common libraries.

Should be fairly easy to package it for IOS, since the framwork and libraries seem to have support.

## Possible future extensions
* IOS support
* Tweakable notification settings (nagginess, awake time interval)
* More nudges
* Nudge source material (why is this nudge a good idea? who recommends it?)
* User generated nudges, nudge rating

## Lessons learned
* Flutter dev environment was a bit hard to set up on Windows 10 Home with an AMD processor.
  Kept wanting me to install Intel HAXM. I switched to develop on OSX.

* Don't work on features until last minute ;)

* I takes time to become a minimum level of proficient in a new language (Dart) an new framework (Flutter)
  and a new domain (app development) ;). The fact that it is possible at all is a good score for
  Flutter framework, dev environment and documentation, and some google-fu on my part :)

## Author
Björn Löfroth

## License
Apache License 2.0