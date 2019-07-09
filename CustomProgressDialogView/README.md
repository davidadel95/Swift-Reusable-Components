# Custom Progress Dialog Popup


## About

Custom generated progress dialog popup to be used as a loading view based on NicoProgressBar pod
(https://github.com/CityTransit/NicoProgress)

## Usage

Use NicoProgressBar in your nib or add it programmatically as a subview.

#### Show popup

1- Add the UIViewController+Extension.swift to your project

2- Call the function with your custom message
```
self.showProgressDialoag(message: "Your message goes here")
```
3- Dismiss the progress dialog
```
self.dismissPorgressDialog()
```

#### Colors
```
progressBar.primaryColor = .blue
progressBar.secondaryColor = .white
```
#### Set Progress
```
progressBar.transition(to: .determinate(percentage: 0.5))
```
#### Indeterminate
```
progressBar.transition(to: .indeterminate)
```
#### State
```
let state = progressBar.state
```

## Requirements
iOS Deployment Target >= 8.0
Swift 3.2 or 4

## Installation

NicoProgress is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NicoProgress'
```

## License

NicoProgress is available under the MIT license. See the LICENSE file for more info.

