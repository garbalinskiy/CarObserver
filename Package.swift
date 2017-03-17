import PackageDescription

let package = Package(
    name: "CarObserver",
    dependencies: [
        .Package(url: "https://github.com/tid-kijyun/Kanna.git", majorVersion: 2),
    ]
)
