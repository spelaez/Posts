# Posts

This is a small iPhone App that fetches some JSONs from service and cache some of the data.
You can see a list of Posts, with a list comments in the detail and the user that created it. You can also mark a post as favorite and keep track of the posts you have not read yet as well as delete and recover deleted posts.

## Getting started

### System requirements
Xcode 11.x, cocoapods 1.7.5 or higher and the minimum macOS version required by your Xcode version.

### Building 

1. Clone the repository 
2. Open a terminal and navigate to project's folder `Posts/`
3. run `pod install` to install required dependencies
4. open `Posts.xcworkspace` on Xcode 11.x
5. Choose an iPhone simulator and make sure `Posts` is the scheme selected
6. click `Product > Run` or `⌘R`

### External Dependencies

- Alamofire `4.9.0`
- RealmSwift `3.19.0`

## Architecture

For this project, I used VIP architecture from `https://clean-swift.com/`.
It consists of a unidirectional cycle where the main actors (view controller, interactor and presenter) hold a single responsibility on a feature. 

The view controller is in charge of UI updates acting as Controller and to listen to user actions acting as View, the interactor needs to gather requested data from service or local persistence and the presenter formats this data (if needed) into something user-friendly.
Some secondary actors can help main actors in complex tasks; these are the workers and the routers.
The workers can help interactors on data management such as fetching data from service.
The routers extract the navigation and data-passing logic from the view controller.

To completely decouple the VIP components we define data models to pass through the boundaries between them instead of using just raw data models. There are 3 primary types of models:

- Request: Constructed by the view controller and passed to the interactor. it contains mostly user inputs.
- Response: After Interactor finishes doing work for a request, it constructs a response model encapsulating the result and passes it to the Presenter.
- ViewModel: After the presenter receives a response from the Interactor it formats the result and stuff in the view model. it then passes back to the view controller for display

### General pros

- Add new features easily.
- Write shorter methods with a single responsibility.
- Decouple class dependencies with established boundaries.
- Extract business logic from view controllers into interactors.
- Find and fix bugs faster and easier.
- Prevent massive view controllers.

## 3rd Parties

### Alamofire

One of the most pupular Swift framworks available. it is a well maintained framework that makes easier implementing networking on apps.
Nowadays the URLSession APIs are easier to use than some time ago, but I choose Alamofire for time saving and simplicity.

### Realm

3rd Party framework for handling persistency, it is faster to adopt and easy to understand. As Alamofire over URLSession I choosed this over Core Data for time saving and simplicity. Core Data requires more configuration and with Realm I only have to inherit from `Object` and change my model changes to use `realm.write`.
