## MovieApp

## How to Run?
- Please create a configuration file in the "Config" folder, named Config.xcconfig, or refer to the ExampleConfig.xcconfig file. Then, copy and rename it to `Config` and paste your `API_KEY`.
- Add the following line to the file: `API_KEY={your-api-key}`
- {your-api-key} is your personal API key for the TMDB service.
- Apply the newly created configuration file in your project's configuration section. Below are links where you can read more about .xcconfig files in detail.
	- https://help.apple.com/xcode/#/dev745c5c974
    - https://developer.apple.com/documentation/xcode/adding-a-build-configuration-file-to-your-project

#### Requirements
- **Platform**: iOS 14.0.
- **Networking**: `URLSession`
- **Architecture**: MVVM + Coordinator + Combine.
- **UI**: UIKit + AutoLayout (Native Anchors).
- **3rd-part-libs** combine-interception, CombineCocoa, CombineExt, Kingfisher, Connectivity

#### Other
 - Support English and Ukrainian
 - DI
 - Logger
 - SwiftLint

## Screens
  - Popular Movies List.
  - Movie Details.
  - Fullscreen Photo Sizing.
  - Display an alert when you become offline.
