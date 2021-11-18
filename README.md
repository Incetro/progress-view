<H1 align="center">ProgressView</H1>

<p align="center">
<a href="https://cocoapods.org/pods/progress-view"><img alt="Version" src="https://img.shields.io/cocoapods/v/progress-view.svg?style=flat"></a> 
<a href="https://github.com/Incetro/progress-view/blob/master/LICENSE"><img alt="Liscence" src="https://img.shields.io/cocoapods/l/progress-view.svg?style=flat"></a> 
<a href="https://developer.apple.com/"><img alt="Platform" src="https://img.shields.io/badge/platform-iOS-green.svg"/></a> 
<a href="https://developer.apple.com/swift"><img alt="Swift4.2" src="https://img.shields.io/badge/language-Swift5.0-orange.svg"/></a>
</p>

## Description

This library is a custom progress view.
 
- [Usage](#Usage)
- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [Authors](#license)

## Usage <a name="Usage"></a>

To use a *ProgressView*, all you need is to import `ProgressView` module into your swift file:

```swift
import ProgressView
```

There are two types: `ProgressBar` and `ProgressRing`. Both of them have similar properties and methods. Public properties are designed to customize the desired appearance, fill animation and property `progress` to get current progress value.

```swift
/// ProgressBar instance
let progressBar = ProgressBar()

/// The first gradient color
progressBar.startColor = .red

/// The second gradient color
progressBar.endColor = .green

/// The groove color in which the fillable ring resides
progressBar.grooveColor = .blue

/// Timing function of the progress fill animation
progressBar.timingFunction = .easeInEaseOut

/// Printing current progress value
print(progressBar.progress) // outputs a Float value from 0 to 1

/// Setting progress
progressBar.setProgress(0.5, animated: true, completion: nil)
```

You can do the same with ProgressRing and you can do a bit more, such as setting up the ring itself.

```swift
/// ProgressRing instance
let progressRing = ProgressRing()

/// Sets the line width for progress ring and groove ring
progressRing.lineWidth = 15

/// The line width of the progress ring
progressRing.ringWidth = 10

/// The line width of the groove ring
progressRing.grooveWidth = 10

/// The radius of the ring
progressRing.ringRadius = 36

/// The radius of the groove
progressRing.grooveRadius = 36
```


## Requirements
- iOS 13.0+
- Xcode 9.0
- Swift 5.0

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.


## Installation <a name="installation"></a>

### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To install it using [CocoaPods](https://cocoapods.org), simply add the following line to your Podfile:

```ruby
use_frameworks!

target "<Your Target Name>" do
pod "progress-view", :git => "https://github.com/Incetro/progress-view", :tag => "[1.0.0]"
end
```
Then, run the following command:

```bash
$ pod install
```
### Manually

If you prefer not to use any dependency managers, you can integrate *ProgressView* into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add *ProgressView* as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/incetro/progress-view.git
  ```

- Open the new `ProgressView` folder, and drag the `ProgressView.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `ProgressView.xcodeproj ` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `ProgressView.xcodeproj ` folders each with two different versions of the `ProgressView.framework` nested inside a `Products` folder.

- Select the `ProgressView.framework`.

    > You can verify which one you selected by inspecting the build log for your project. The build target for `Nio` will be listed as either `ProgressView iOS`.

- And that's it!

  > The `ProgressView.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.
  


## Authors <a name="authors"></a>

incetro: incetro@ya.ru, Gasol: 1ezya007@gmail.com


## License <a name="license"></a>

*ProgressView* is available under the MIT license. See the LICENSE file for more info.
