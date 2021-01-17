# Flutter Weather App

A new Flutter project.

## Getting Started

### Dependencies
#### Add the following packages to your `pubspec.yaml` file
      cupertino_icons: ^1.0.0
      geolocator: ^6.1.13
      http: ^0.12.2
      floating_search_bar: ^0.3.0
      date_format: ^1.0.9
      loading: ^1.0.2
#### Enable these permissions in your `android/app/src/main\AndroidMainfest.xml` file
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    
#### Add the following code segment to check if your permissions are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
