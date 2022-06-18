# ITunesFeedGenerator

This library provides very simple and Swiftly way to fetch feeds from iTunes Store:
- Most Played Songs.
- Top Free or Paid Books. 
- Top Free or Paid Apps.
- Most Played Albums/Music Videos/Playlists (Coming Soon).
- Top Podcasts/Podcast Episodes (Coming Soon).
- Top Audio Books (Coming Soon).

## Features
- Pass region code as parameter.
- Pass result limit (10, 25, 50) as parameter.
- Pass `top free` or `top paid` enum for books or apps feed
- Swift Async Await Interface

## Installation

A detailed guide for installation can be found in Installation Guide.

### Swift Package Manager

- File > Swift Packages > Add Package Dependency
- Add https://github.com/alfianlosari/ITunesFeedGenerator.git
- Select "Main" branch

## Example

### Initialize repository

First of all, you need to initalize the `FeedRepository`.

```swift
let repository = FeedRepository()
```

### Fetch most played songs

```swift
// Fetch top 50 most played songs in Indonesia
let songs = try await repository.getMostPlayedSongsFeed(region: "id", resultLimit: .limit50)
```

### Fetch top free or top paid apps

```swift
// Fetch top 10 free apps in Great Britain
let topPaidApps = try await repository.getTopAppsFeed(region: "gb", type: .topFree, resultLimit: .limit10)

// Fetch top 25 paid apps in Singapore
let topPaidApps = try await repository.getTopAppsFeed(region: "sg", type: .topPaid, resultLimit: .limit25)
```

### Fetch top free or top paid books

```swift
// Fetch top 10 free books in Great Britain
let topPaidApps = try await repository.getTopBooksFeed(region: "gb", type: .topFree, resultLimit: .limit10)

// Fetch top 25 paid books in United States
let topPaidApps = try await repository.getTopBooksFeed(region: "us", type: .topPaid, resultLimit: .limit25)
```

### Supported Region Code Strings

You can get the list of all supported region code parameters from this [GitHub Gist](https://gist.github.com/daFish/5990634). Kudos to [Marcus Stöhr/daFish](https://gist.github.com/daFish)
