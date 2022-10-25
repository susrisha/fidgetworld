# Fidget world sample application for nymi
This is a POC of application that helps in invoking a user intent from a web browser. 

# Components

There are two components involved in this application. 

1. Website with html content (present in `index.html`)
2. Source code of the application that handles the web invocation (present in `ios-src` folder) under the name `matsya`

## matsya

The application has the code handler that enables the application to react to the web needs. The actual UI does not have any specific code itself.

The application listens and is registered for the URL type `matsya`. Hence the application opens to the URLs like below:

`matsya://?bandId=<>`

`matsya://?bandId=<>&orgId=<>&sourceUrl=<>`

## Web page
The web page is hosted currently in github.io and can be accessed on the phone with the URL 

https://susrisha.github.io/fidgetworld/

The code of the site can be updated by simply updating the code for `index.html`


## Functionality/ Design

The application is designed to look for the following query Items in the launch URL if it is invoked via web app
- bandId < The Band ID to scan for>
- userId < The user Id for reference>
- sourceUrl < The return URL for the app to return to.>

The `sourceUrl` is the required parameter. Every other parameter can be changed. The `sourceUrl` has to be the same URL as the webapp that is launching. This can be easily obtained using `window.location.href`. This is so that the application can return back to the safari browser automatically once the processing is done. Safari ensures to launch the same window if there is a window open.

The class `BLEHandler` handles the BLE interaction. At the moment the code is restricted to reading the characteristics and can be enhanced based on the need.

NOTE:
- There is a POD inclusion but not used. This was used earlier for socket communication but was discarded.
- The code is kept POD ready just in case additional libraries may be needed
