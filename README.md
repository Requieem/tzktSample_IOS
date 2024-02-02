<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GNU GPLv3.0 License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

# tzktSample

`tzktSample` is a SwiftUI application developed in Xcode, designed to fetch and display lists of blockchain blocks and transactions using the tzkt.io REST API. This project showcases SwiftUI views, ViewModel architecture, and network request handling in Swift.

## Features

- Fetch and display a list of blockchain blocks.
- Fetch and display transactions for a specific block.
- Pull-to-refresh functionality in lists.
- Dependency injection for network services, enhancing testability.
- Comprehensive unit tests for ViewModels and network services.

## Required Tech

All the version reported below are what the app was built and tested with, forward or backward compatibility should not be a problem but is not guaranteed. Please report any incompatibilities.

- iOS 16.4+ (should be good down to around 15.0)
- Xcode 14.0+
- Swift 5.0+

## Installation

Clone the repository, and open the project in Xcode:

```bash
git clone https://github.com/Requieem/tzktSample_IOS.git
cd tzktSample
open tzktSample.xcodeproj
```

## Usage

The application consists of two main views:

1. **BlockListView**: Displays a list of blockchain blocks. Each block can be tapped to view its transactions.

2. **TransactionListView**: Shows transactions for the selected block.

Pull down on either list to refresh the content.

## Architecture

This project follows the MVVM (Model-View-ViewModel) architecture:

- **Model**: Represents the data structure (e.g., `Block`, `Transaction`).
- **View**: SwiftUI views for user interface (e.g., `BlockListView`, `TransactionListView`).
- **ViewModel**: Logic layer that handles data fetching and processing (e.g., `VM_BlockTable`, `VM_TransactionTable`).

## Networking

Network requests are handled by `APIService`, which is abstracted behind `URLSessionProtocol` to enable mocking for unit tests.

## Testing

Unit tests are written using XCTest framework. `MockURLSession` and `MockAPIService` are used to simulate network responses.

## Folder Structure

This is the current structure of the project:

```
tzktSample/
│
├── Fonts/
│ └── Urbanist/
│
├── tzktSample/
│ ├── Utility/
│ │ ├── CustomDateFormatter.swift
│ │ ├── CustomJsonDecoder.swift
│ │ └── APIService.swift
│ │
│ ├── Protocols/
│ │ └── URLSessionProtocol.swift
│ │
│ ├── ViewModel/
│ │ ├── VM_BlockTable.swift
│ │ └── VM_TransactionTable.swift
│ │
│ ├── View/
│ │ ├── BlockTable.swift
│ │ ├── TransactionTable.swift
│ │ └── Header.swift
│ │
│ └── Model/
│ └── tzktSampleApp/
│
├── Assets/
│ └── Preview Content/
│
└── tzktSampleTests/
├── Mocks/
│ ├── MockURLSession.swift
│ ├── MockDecodable.swift
│ └── MockAPIService.swift
│
├── APIServiceTests.swift
├── VM_BlockTableTests.swift
└── VM_TransactionTableTests.swift
```

## External Tools

During the development of `tzktSample`, several external tools were utilized to aid in the design, testing, and validation of the application:

### Postman

[Postman](https://www.postman.com/) was used for testing and interacting with the tzkt.io REST API. This helped in understanding the API responses and structuring the network layer of the app accordingly.

To explore and test the API endpoints used in this project, you can use the following Postman collection:

[<img src="https://run.pstmn.io/button.svg" alt="Run in Postman" style="width: 128px; height: 32px;">](https://app.getpostman.com/run-collection/8834599-7fed6ab0-b9ad-4317-93ad-13a5e147146b?action=collection%2Ffork&source=rip_markdown&collection-url=entityId%3D8834599-7fed6ab0-b9ad-4317-93ad-13a5e147146b%26entityType%3Dcollection%26workspaceId%3D4e24ead8-cf4c-4f93-812c-b57520f56be7)

### Figma

The user interface design and prototyping were conducted using [Figma](https://www.figma.com/). Figma enabled quick iteration over the app's UI/UX design, ensuring a user-friendly experience.

You can view the Figma designs for this project here: [TZKT Figma Design](https://www.figma.com/file/yKZsuXchaKucxXkJW1WEt5/TZKT?type=design&node-id=0%3A1&mode=design&t=zjWbkbaXMDj21oBJ-1)

## License

This project is licensed under the GNU GPLv3.0 License - see the [LICENSE](LICENSE) file for details.

## Credit where it's due

This README.md file was structured following [this awesome template](https://github.com/othneildrew/Best-README-Template/blob/master/BLANK_README.md)!

<!-- MARKDOWN LINKS & IMAGES -->
[forks-shield]: https://img.shields.io/github/forks/Requieem/tzktSample_IOS.svg?style=for-the-badge
[forks-url]: https://github.com/Requieem/tzktSample_IOS/network/members
[stars-shield]: https://img.shields.io/github/stars/Requieem/tzktSample_IOS.svg?style=for-the-badge
[stars-url]: https://github.com/Requieem/tzktSample_IOS/stargazers
[issues-shield]: https://img.shields.io/github/issues/Requieem/tzktSample_IOS.svg?style=for-the-badge
[issues-url]: https://github.com/Requieem/tzktSample_IOS/issues
[license-shield]: https://img.shields.io/github/license/Requieem/tzktSample_IOS.svg?style=for-the-badge
[license-url]: LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/marco-farace/
