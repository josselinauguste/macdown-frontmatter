Gist it! for MacDown
=====================

This repository illustrates a basic example of a plug-in for [MacDown], the open source Markdown editor for OS X. It provides a menu item “Gist it!” that uploads the current document (if available) as a public [GitHub Gist].

> Note: Plug-ins are available in MacDown 0.6+ only. This particular plug-in works only under OS X 10.9 or later, not 10.8.

[MacDown]: http://macdown.uranusjr.com
[GitHub Gist]: https://gist.github.com

### Installation

Put `macdown-gistit.plugin` in `~/Library/Application Support/MacDown/PlugIns`.

### Usage

Open a document, and select menu item **Plug-ins → Gist it!** to upload. An alert dialog will appear to indicate whether the operation is successful. If the gist is created successfully, its URL will be copied automatically into your
clipboard, so that you can easily share, or open it inside a browser.

> **Alert!!** This is for demo only. The implementation does not include authentication, and all gists are uploaded anonymously. *You will not be able to delete or modify the Gist. Be careful not to upload anything sensitive.*

### License

[![Created Commons License](https://i.creativecommons.org/l/by-sa/3.0/88x31.png)](http://creativecommons.org/licenses/by-sa/3.0/)<br>
This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).


## The MacDown Plug-in Architecture

This section serves as a simple walkthrough on how plug-ins work in MacDown until proper documentation is written. Hopefully not by myself. :p

### Introduction

A plug-in in MacDown is a regular Cocoa [dynamic-loading bundle], with extension `.plugin`. MacDown searches `~/Library/Application Support/MacDown/PlugIns`, and builds menu items for loadable bundles inside the directory. A plug-in is invoked when the user clicks on its corresponding menu item.

One caveat is that MacDown does *not* reuse plug-in instances between invocations; a new instance is re-created each time a method is called on the plug-in. This may change in the future, but as a rule of thumb, you should always treat your plug-in as stateless. Store things with `NSUserDefaults` or other persistence solutions.

[dynamic-loading bundle]: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/LoadingCode/LoadingCode.html#//apple_ref/doc/uid/10000052-SW1


### Plug-in Architecture

A plug-in project can be created via Xcode’s **OS X → Framework & Library → Bundle** project template. You should set up the project meta data according to Apple’s documentation, specifically provide a *Principle Class* config that points to the appropriate class inside the project as your plug-in’s entry class.

A plug-in should provide two methods inside the principle class:

**`- (NSString *)name`**

This indicates the name of the plug-in. MacDown will use the value returned by this method as the menu item’s title for your plug-in.

**`- (BOOL)run:(id)sender`**

This method will be invoked when your plug-in is run. the `sender` argument indicates the UI item that triggers the invocation—usually the `NSMenuItem` object the user clicked on, but could also be `nil` if the plug-in is triggered programmatically.

The return value indicates whether the plug-in is invoked successfully.

This method may be invoked in the UI thread. Therefore, it is strongly recommended you push long operations into background threads, and/or run them asynchronously.

### Tips

MacDown uses the standard OS X document-based application structure. This means that you can get almost all information via the standard `NSDocumentController` API. Refer to the official documentation for more detail.

A document instance in MacDown provides two additional properties:

**`@property (nonatomic, readwrite) NSString *markdown`**

This holds the string inside the editor. Writing to this property modifies the editor content.

**`@property (nonatomic, readonly) NSString *html`**

This holds the *rendered* HTML content.
