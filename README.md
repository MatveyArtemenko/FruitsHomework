
# FruitList Mobile App

This mobile application is designed to display information about various fruits. It consists of two screens - the first screen shows a list of fruits, and the second screen provides more detailed information about a selected fruit, including its price and weight.

## Features

- Display a list of fruits on the first screen.
- Show detailed information about a selected fruit on the second screen (price in pounds and pence, weight in kg).
- Download fruit data from a JSON file hosted on a web server.
- Allow users to manually reload data from the server.
- Generate usage statistics by issuing GET requests to a stats endpoint.

## Data Source

The fruit data is retrieved from the following JSON file hosted on a web server:
- [Fruit Data JSON](https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/data.json)

## Usage Stats

Usage statistics can be generated by issuing GET requests to the following stats endpoint:
- [Stats Endpoint](https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/stats)

Parameters to be appended to the URL:
- `event=load` - for any network request, associated data is the time in ms for the complete request.
- `event=display` - whenever a screen is shown, associated data should be the amount of time taken (in ms) from when the user initiated a request that would show the screen to the point where the screen has finished drawing.
- `event=error` - sent whenever there is a raised exception or application crash, associated data would be something useful for a developer to use in response to "live issues".

Example usage stats URLs:
- [Load Event Example](https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/stats?event=load&data=100)
- [Display Event Example](https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/stats?event=display&data=3000)
- [Error Event Example](https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/stats?event=error&data=null%20pointer%20at%20line%205)