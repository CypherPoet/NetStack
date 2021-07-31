# NetStack 🛰

<!-- Header Logo -->

<!-- <p align="center">
   <img width="600px" src="./Resources/Assets/banner-logo.png" alt="Banner Logo">
</p> -->


<!-- Badges -->

<p>
    <img src="https://img.shields.io/badge/Swift-5.5-F06C33.svg" />
    <img src="https://img.shields.io/badge/iOS-15.0+-865EFC.svg" />
    <img src="https://img.shields.io/badge/iPadOS-15.0+-F65EFC.svg" />
    <img src="https://img.shields.io/badge/macOS-12.0+-179AC8.svg" />
    <img src="https://img.shields.io/badge/tvOS-15.0+-41465B.svg" />
    <img src="https://img.shields.io/badge/watchOS-8.0+-1FD67A.svg" />
    <img src="https://img.shields.io/badge/License-MIT-blue.svg" />
    <img src="https://github.com/CypherPoet/NetStack/workflows/Build%20&%20Test/badge.svg" />
    <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" />
    </a>
    <a href="https://twitter.com/cypher_poet">
        <img src="https://img.shields.io/badge/Contact-@cypher_poet-lightgrey.svg?style=flat" alt="Twitter: @cypher_poet" />
    </a>
</p>



<p align="center">

_A concurrency-based networking stack for modern Swift projects. Use as-is &mdash; or as a starting point for your own utilities._

<p />


## Features

- ✅ Composable, async-enabled primitives for performing network operations with `Data` and transforming `Codable` types.
- ✅ Utilities for `URLRequest` configuration.
- ✅ Utilities for mocking `URLRequest` responses in tests.


## Installation

`NetStack` ships with two [library products](https://developer.apple.com/documentation/swift_packages/product): `NetStack` and `NetStackTestUtils`.


### Xcode Projects

Select `File` -> `Swift Packages` -> `Add Package Dependency` and enter `https://github.com/CypherPoet/NetStack`.


### Swift Package Manager Projects

You can add `CypherPoetNetStack` as a package dependency in your `Package.swift` file:

```swift
let package = Package(
    //...
    dependencies: [
        .package(
            name: "CypherPoetNetStack",
            url: "https://github.com/CypherPoet/NetStack",
            .exact("0.0.5")
        ),
    ],
    //...
)
```

From there, refer to the `NetStack` "product" delivered by the `CypherPoetNetStack` "package" inside of any of your project's target dependencies:

```swift
targets: [
    .target(
        name: "YourLibrary",
        dependencies: [
            .product(
                name: "NetStack",
                package: "CypherPoetNetStack"
            ),
        ],
        ...
    ),
    ...
]
```

Then simply `import NetStack` wherever you’d like to use it.


## Usage

### Projects Using NetStack

-


## Contributing

Contributions to `NetStack` are most welcome. Check out some of the [issue templates](./.github/ISSUE_TEMPLATE/) for more info.




## 💻 Developing

### Requirements

- Xcode 13.0+


### 📜 Creating & Building Documentation

Documentation is built with [Xcode's DocC](https://developer.apple.com/documentation/docc). See [Apple's guidance on how to build, run, and create DocC content](https://developer.apple.com/documentation/docc/api-reference-syntax).

For now, the best way to view the docs is to open the project in Xcode and run the `Build Documentation` command. At some point in the future, I'm hoping to leverage the tooling the develops for generating/hosting DocC documentation. (Please feel free to let me know if you have any ideas or tooling recommendations around this 🙂).



## 🏷 License

`NetStack` is available under the MIT license. See the [LICENSE file](./LICENSE) for more info.
