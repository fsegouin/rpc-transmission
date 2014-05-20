# Transmission RPC Client for iOS

![app icon](http://0three0.net/wp-content/uploads/2010/08/transmission_logo.png)

## Caution

This project is still at an early development stage and should not be used in any app.
I know it's messy, ugly and not fully functional. It was coded in one night a few months ago.
I will try to improve this app when I will have some free time though.

## Releases

None. Still in development.

## Installation

### Step 1 : Clone this repo
Run the following command line in Terminal (Protip: use [iTerm2](http://www.iterm2.com/#/section/home)):

	$ git clone https://github.com/fsegouin/rpc-transmission.git

### Step 2 : Install [CocoaPods](http://cocoapods.org/)
In your repo directory, run the following (only if you don't have CocoaPods):

	$ sudo gem install cocoapods

### Step 3 : Install pods
Create a Podfile and insert the following:

> platform :ios, '7.0'
>
> pod "AFNetworking", "~> 2.0"

Then run the following command :

	$ pod install

### Final Step

Open the .xcworkspace file that Cocoapods generates in your project directory.
