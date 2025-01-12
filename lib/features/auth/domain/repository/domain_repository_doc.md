## Domain -> Repository
- Domain layer is the inner most layer of the clean architecture
- So, it should not depend on any other layer
- here we define the repository interface that will be implemented by the data layer
- domain repository is like a contract between the domain layer and the data layer


### Benefits os having contract (i:e interface) in domain layer

- it allows us to define the methods that the data layer must implement
- when there will be some changes in the data layer, we will only need to update the data layer and the domain layer will remain the same
- So, domain and data layer will be decoupled