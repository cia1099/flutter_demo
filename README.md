# Config

* [.mockend.json](.mockend.json)

# REST examples

- https://mockend.com/cia1099/temp_demo/posts
- https://mockend.com/cia1099/temp_demo/posts/1
- https://mockend.com/cia1099/temp_demo/posts?limit=5
- https://mockend.com/cia1099/temp_demo/posts?createdAt_order=desc
- https://mockend.com/cia1099/temp_demo/posts?gotItems_gt=3


# GraphQL examples

- https://mockend.com/cia1099/temp_demo/graphql

# Emulator
* Copy local file to emulator
```shell
# when turn on emulator
adb push <PC path> <emulator path>
adb push ~/project/test.txt /storage/emulated/0/Download/
# entry emulator system
adb shell
```
ref. https://stackoverflow.com/questions/5151744/upload-picture-to-emulator-gallery

## Colorized Console

Here is the string to turn Hello red:
```
\x1B[31mHello\x1B[0m
```
```
\x1B  [31m  Hello  \x1B  [0m
```
Meaning:

* \x1B: ANSI escape sequence starting marker
* [31m: Escape sequence for red
* [0m: Escape sequence for reset (stop making the text red)

Here are the other colors:
```
Black:   \x1B[30m
Red:     \x1B[31m
Green:   \x1B[32m
Yellow:  \x1B[33m
Blue:    \x1B[34m
Magenta: \x1B[35m
Cyan:    \x1B[36m
White:   \x1B[37m
Reset:   \x1B[0m
Background Bright Black: \x1B[40;1m
Background Bright Red: \x1B[41;1m
Background Bright Green: \x1B[42;1m
Background Bright Yellow: \x1B[43;1m
Background Bright Blue: \x1B[44;1m
Background Bright Magenta: \x1B[45;1m
Background Bright Cyan: \x1B[46;1m
Background Bright White: \x1B[47;1m
```

ref. \
https://stackoverflow.com/questions/54018071/how-to-call-print-with-colorful-text-to-android-studio-console-in-flutter\
[Build your own Command Line with ANSI escape codes](https://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html)
