# Morgantown Bus & PRT Tracker 
###### Official iOS repository

#### [Play Store](https://play.google.com/store/apps/details?id=com.slheavner.wvubus) | [App Store](https://itunes.apple.com/us/app/morgantown-bus-prt-tracker/id993385664?ls=1&mt=8) | [Website](http://morgantownbustracker.org) ![Alt text](https://raw.github.com/slheavner/mbt-android/master/app/src/main/res/drawable-xxxhdpi/ic_launcher.png "mbt-android logo")

**This project has no relation to West Virginia University (WVU) or Mountain Line Transit Authority**

-----
### mbt-ios
Other compenents
* [mbt-api](https://github.com/slheavner/mbt-api)
* [mbt-android](https://github.com/slheavner/mbt-android)

##### Setup
The project requires a Bus API URL and a Google Maps API Key as strings in **Config.plist**. A sample file, **example.Config.plist** is provided

![plist setup](http://i.imgur.com/Ded8iwr.png)

The Bus API URL is what the app talks to, which is the [mbt-api repository](https://github.com/slheavner/mbt-api)  
Follow the setup instructions there to setup your own API service.

This project requires CocoaPods for Google Maps and Google Analytics Pods. You can find more info [here](https://cocoapods.org/). The Pods are not included
because they are huge. You will have to install them yourself.
```Shell
sudo gem install cocoapods
cd /path/to/mbt-ios
pod install
```

-----
##### About

This project is the Android app for the Morgantown Bus & PRT Tracker project. It was made out of a need to track the buses around Morgantown, WV, as a West Virginia University student. It was also made because *programming is fun*.

-----
##### License
```
Copyright 2015 Samuel Heavner

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this software except in compliance with the License.
You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
