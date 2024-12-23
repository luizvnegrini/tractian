# Tractian Challenge

This project is a simple Flutter application developed for a technical test for Tractian. 

# Demo
https://github.com/user-attachments/assets/8f028b04-97dc-4d75-985f-405ce3644225

## Main Technologies
- Flutter
- Bloc
- GoRouter
- Dartz
- Mocktail

## Features
- Fetch and display assets and locations
- Search assets and locations
- Build tree nodes

## SETUP

### **0 Install Flutter Framework**

[See docs here.](https://docs.flutter.dev/get-started/install)

## **1. Running the project**

First of open your terminal and go to the app main folder and run `flutter pub get` to resolve dependencies.

To run, take into account the flavors `dev`, `hml` e `prod`.  

Always run as follows:  

```bash
cd app
flutter run -t lib/main-<flavor>.dart --flavor <flavor> 
```

## **2 Creating/editing flavors**

For the creation of flavors, the package [flutter_flavorizr](https://github.com/AngeloAvv/flutter_flavorizr) was used.

Follow your documentation for adding/editing flavors.


## **3. Tests**

To maintain organization, each test file must be created in the same folder structure as the file being tested. Example:

```bash
# Implementation
/app
  /lib
    /domain
      /usecases
        /build_tree_nodes.dart

# Test
/app
  /test
    /domain
      /usecases
        /build_tree_nodes.dart
```


## **4. Design system**

Project uses Atomic Design for create the Design System. Click [here](https://bradfrost.com/blog/post/atomic-web-design/) to read about Atomic Design.

## **5. Critique and improvements**

About the project I tried to deliver something robust but there is always more to do, in this case I would like to perform more tests, different types of tests such as "golden tests" and "widget tests" that were not implemented, reevaluate the code and see if any refactoring would be necessary to leave the cleaner code.

The application has already been architected for a scale of teams, it is already a monorepo and modularized. I didn't create any more modules because it's a simple app, one module is enough, but an example of another module would be any other feature such as authentication, and the others I suggested at the beginning of this file.

It would certainly be possible to solve the problem proposed with a simpler app, but I want to make it clear that I did it in this way and with complexity to meet the request that the app must be scalable and also to show my knowledge, I hope I have fulfilled it.

### **5.1 Improvements**

- Have a more complete error handler
- Golden tests
- Widget tests
