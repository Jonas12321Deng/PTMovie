# Movie Search App
This is a movie search app that allows users to search for movies and view their details. It integrates with the Movie Database API to fetch movie data and provides offline caching using Core Data.

## Prerequisites
Before running the app, ensure you have the following:

- Xcode installed on your Mac
- An active internet connection to fetch movie data from the API

## Installation
* Clone or download the repository to your local machine.
* Open the PTMovie.xcodeproj file in Xcode.

## Configuration
1) Obtain an API key from the Movie Database API. You can sign up for an account and generate an API key here.
2) Open the MovieDatabaseAPI.swift file.
3) Replace the placeholder value for apiKey with your generated API key.
4) Building and Running

## Usage
1) Upon launching the app, you will see a search bar at the top of the screen.
2) Enter the name of a movie you want to search for and tap the "Search" button on the keyboard.
3) The app will fetch movie data from the API and display the results in a table view.
4) Scroll down to load more search results as you reach the bottom of the screen.
5) Tap on a movie in the list to view its details.
6) You can go back to the search results by using the navigation bar's back button.

## Offline Caching
- If you have a network connection, the app will fetch movie data from the API and cache the results locally using Core Data.
- If you don't have a network connection, the app will retrieve the cached data and display it instead.
- The cached data will be used until you have a network connection and new movie data is fetched from the API.

## Dependencies
- This app uses Cocoapods as a dependency manager. The necessary dependencies are listed in the Podfile.
- After cloning the repository, run pod install in the project directory to install the required dependencies.
