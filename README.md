# Network-Logger
Instabug task.

You can use this framework to make http requests as (Get - Post - Put - Delete)
The framework saves all your networks calls in the session.

## Getting started

### Installation

1- Download the repo and drag InstabugInterview.xcodeproj to your project.<br />
2- In your app target add new framework and choose InstabugNetworkClient.

### Testing

For testing the framework you can run the Example project in the repo.

### Usage

```swift
// 1) Import the client API package.
import InstabugNetworkClient

// 2) Create a client.
let networkClient = NetworkClient.shared

// 3) For using an HTTP method.
networkClient.get(url) { data in
   ///
}
// 4) For fetching all the apis calls that recorded in session.
let records = networkClient.allNetworkRequests()
```

## Notes

- The maximum api calls that can be saved is 1000, and If you exceeded the limit the framework starts to remove earlier calls.

- The maximum size for the payload is 1 MB, and if it exceeded the limit the framework saves ("payload too large") instead

- With every launch of your app all of the previously network calls will be deleted.

