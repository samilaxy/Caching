
Caching

### Caching, Dependency Injection & State Restore.\*

Create a mobile application.

1.  You need 2 activities/controllers/pages. One with a recycler view / collection view that shows a grid of images (2 columns) from the Unsplash API (<https://unsplash.com/developers>) and another to show a single tapped image. (Don't store your keys literally in the app)

2.  Create all views in this app with code (no xml or storyboard).

3.  Create your own class for displaying and caching (no use of Dbs or Shared Preference or UserDefaults) the images being showed (no external libraries). Only load images from the api if there are no images in the cache.

4.  Use a Dependency Injection library in your development.
5.  Save the state of the app when it closes and restore it when it’s reopened.
