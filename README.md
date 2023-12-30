# Flutter Gemini Bot

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Description

`flutter_gemini_bot` is a package that allows you to easily create a chat bot application in Flutter.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Features

This package provides a `FlutterGeminiChat` widget that you can use to create a chat bot interface in your Flutter application.

## Getting Started

To use this package, you will need:

- A list of `ChatModel` objects representing the chat messages or sessions
- An API key for authenticating with the chat bot service
To use the Gemini API, you'll need an API key. If you don't already have one, create a key in [Google AI Studio](https://ai.google.dev/). Get an API key.

## Usage

Here is an example of how to use the `FlutterGeminiChat` widget:

```dart
List<ChatModel> chatList = []; // Your list of ChatModel objects
String apiKey = 'your_api_key'; // Your API key

FlutterGeminiChat(
  chatContext: 'example_context',
  chatList: chatList,

  apiKey: apiKey,
)
```
 

## Contributing

This project is open source and we welcome contributions. Please feel free to submit a pull request or open an issue.

## License

This project is licensed under the MIT License.
