## Weather App

* This is a hybrid UIKit/SwiftUI app. 
* It uses Apple's new async-await framework for networking (since that's the future of Apple's multi-threaded I/O apparently).
* You will need to launch the workspace, not the project, because the app separates the data layer from the business logic, allowing the core app the be substituted with prototypes. 
* This also helps in maintaining the data layer as a set of simple protocols for unit testing. 
* Models have unit test coverage.
* You will need to add either your own Google Places API key or the one provided by the recruiter. Add it in Constants.swift.