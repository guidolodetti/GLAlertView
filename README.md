# GLAlertView - Custom alert view for iOS made in Swift
This simple class in Swift lets you use a custom Alert View in just two lines of code. You can easily customize main parameters such as background color, text colors and fonts.
Currently, the alert works only with a maximum of two buttons: a cancel button and another button, or two normal buttons (provided as an array of strings).

### Usage
Add the file to your project and you are ready!

###### Examples

```
// EXAMPLE 1 WITH COMPLETION BLOCK AND TWO BUTTONS
GLAlertView(title: "This is the title", message: "This is an example message. Each label can be long more than one line.", cancelButtonTitle: "CANCEL", otherButtonTitles: ["OK"]).show({ (alertView, buttonIndex) -> Void in
    if alertView.cancelButtonIndex == buttonIndex {
        // CANCEL BUTTON WAS PRESSED
    } else {
        // OTHER BUTTON WAS PRESSED
    }
})

// EXAMPLE 2 WITH NO COMPLETITION BLOCK AND ONLY ONE BUTTON
GLAlertView(title: "This is the title", message: "This is an example message. Each label can be long more than one line.", cancelButtonTitle: nil, otherButtonTitles: ["OK"]).show(nil)
```

###### Notes
This class was made for a personal project and it can be improved a lot (more than two buttons, landscape mode...).
You are free to edit the code as you want. The current code is commented as much as possible and should be very easy to customize. You can change the animations and the layout with just a few lines of code.