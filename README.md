# ios-swift-practive-swiftui-swiftdata
Exploring Best Practices for Data-Driven SwiftUI Apps with SwiftData.

## Overview
This project delves into various architectures powered by SwiftData to uncover best practices for crafting data-driven SwiftUI apps that uphold efficiency, maintainability, and scalability.

## SwiftData with ViewModel
SwiftData's approach to data management often reduces the need for traditional ViewModel, as it handles queries and data transformations directly within database entities, rather than relying on a separate ViewModel layer for this purpose.

Therefore, we create four apps to compare their architectures and evaluate their effectiveness in different scenarios.
1. Using a pure SwiftData approach 
2. Incorporating SwiftData with ViewModel
3. Pure SwiftData approach with ModelActor for better consistency
4. Incorporating SwiftData with ViewModel with ModelActor

### Starwars
Demonstrates a pure SwiftData implementation, integrating with a REST API.

### StarwarsMVVM
Demonstrates a ViewModel-based approach using SwiftData and a REST API.

In StarwarsMVVM, the approach involves manually fetching SwiftData instead of utilizing @Query annotations for ViewModel usage. This can lead to potential issues, including:

- Redundancy: Manually syncing data between the database and ViewModel can introduce redundancy and increase the likelihood of inconsistencies.
- Manual Database Management: Requires careful manual handling of database consistency to prevent potential app crashes. This risk could reducing by using memory-only data container.

### StarwarsModelActor
Demonstrates a pure SwiftData implementation, integrating with a REST API. Using ModelActor for better consistency.

Although the purporse of ModelActor and ViewModel-based approach differ, their code looks similar.

### StarwarsMVVMModelActor
Demonstrates a ViewModel-based approach using SwiftData and a REST API. Using ModelActor for better consistency.

MVVM with ModelActor is most separated-concerned structure but also have lots of redundancy in code base.
If you need to build complex-data related app, you might consider this approach.


### Conclusion
SwiftData empowers developers to create efficient and maintainable data-driven SwiftUI apps without relying solely on ViewModels. By leveraging its query capabilities and exploring alternative patterns like transformers and repositories, we can achieve well-structured and simplified code that aligns with Swift's evolution.
