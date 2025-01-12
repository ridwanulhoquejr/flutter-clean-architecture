### Domain -> UseCases

Usecases will be depends on the domain -> repository

- UseCases are just a single class that contains a single method. This method is the business logic that we want to execute. 
- The use case is the bridge between the domain and data layers. 
- The domain layer will call the use case and the use case will call the repository. 
- It's responsibility to do only one task, that is expose the business logic to the domain layer. 
- It will be called from the Bloc / provider in the presentation layer.

