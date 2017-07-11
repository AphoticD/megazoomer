# megazoomer #

![megazoomer screenshot](https://github.com/AphoticD/megazoomer/blob/master/megazoomer-screenshot.jpg)

## Introduction ##

**megazoomer** (written by [Ian Henderson](http://ianhenderson.org/megazoomer.html)) enables full-screen support in most Cocoa applications on Mac OS X prior to Mac OS X 10.7 Lion.

**megazoomer** is a **SIMBL** plugin bundle, which is supported on Mac OS X 10.4 Tiger, 10.5 Leopard (PowerPC and Intel) and 10.6 Snow Leopard (Intel 32-bit only). **megazoomer** is not 64-bit compatible and will not work on Mac OS X 10.7 (Lion) or later.

Universal Binary support added by [Mathias Meyer](http://paperplanes.de).


## Installation ##

* Install [SIMBL](http://culater.net/software/SIMBL/SIMBL.php) _(v0.8.2 for Tiger, v0.9.9 for Leopard and Snow Leopard)_
* Download the [megazoomer v0.6 bundle](https://github.com/AphoticD/megazoomer/blob/master/megazoomer_v0.6.zip).
* Drop **megazoomer.bundle** into either /Library/Application Support/SIMBL/Plugins or ~/Library/Application Support/SIMBL/Plugins (create and name these folders as required).

Megazoomer will be available next time you start a Cocoa-based application.


### To Enter Full Screen mode ###

* Choose **"Enter Full Screen"** from the **View** menu _-- OR --_
* Hit **Ctrl-Cmd-F** keyboard shortcut.__*__


### To Exit Full Screen mode ###

* Choose **"Exit Full Screen"** from the **View** menu _-- OR --_
* Hit **Ctrl-Cmd-F** keyboard shortcut.__*__


__*__ _If the app already uses this shortcut, the option modifier key will be added for the shortcut (**Ctrl-Opt-Cmd-F**). Again, if this is in use, then the shortcut will be assigned to **Shift-Opt-Cmd-F** and finally **Shift-Ctrl-Opt-Cmd-F** will be assigned as a last resort if none of the prior shortcuts are available._

-------

## v0.6 Changes [by AphoticD] - 6th July, 2017 ##

* Fixed compatibility issues with Xcode and other apps which use _Objective-C 2.0 Garbage Collection_.
* To be more consistent with functionality found in later Mac OS X (macOS) releases, changed menu command title to "Enter Full Screen" and moved it to the bottom of the **View** menu with shortcut **Ctrl-Cmd-F**.
* Added routine to check keyboard shortcut uniqueness and if the shortcut already exists then it changes to **Ctrl-Opt-Cmd-F**, tests again and tries **Shift-Opt-Cmd-F**, then lastly **Shift-Ctrl-Opt-Cmd-F** - if none are available, the shortcut is ignored.
* Added routine to create _View_ menu (or _Window_ menu in Legacy mode) if the menu does not exist.
* Added routine to toggle menu command title between "Enter Full Screen" and "Exit Full Screen".
* Performed refactoring of some existing methods to use Cocoa framework calls and moved new routines out to class Categories.
* Updated version string.
* Tested PPC Mac OS X 10.5.8 and Mac OS X 10.4.11 running on PowerPC G4 and G5 hardware.
* Tested Intel/i386 Mac OS X 10.5.8 Server and Mac OS X 10.6.8 Server running under VMWare Fusion 8.5.8 on Mac OS X 10.11.6 host (Intel Xeon).
* Found 64-bit Intel/x86_64 apps running on Snow Leopard are not compatible with calls made to the 32-bit objc framework in the 10.4 SDK used by megazoomer "under the hood".


## User Options ##

* Added **User Option** for a comma-separated list of **"ExcludedBundleIdentifiers"** in **megazoomer.bundle/Contents/Info.plist**. Edit the property string using **Property List Editor** or **TextEdit** as needed. Defaults to exclude:
 **'com.apple.finder, com.apple.calculator, com.floodgap.tenfourfox, com.apple.InterfaceBuilder3'**.
* Added **User Option** for **"LegacyMegaZoomInWindowMenu"** in the bundle's _Info.plist_ to restore "Mega Zoom" in the **Window** menu (below "Zoom") with **Cmd-Enter** shortcut (instead of "Enter Full Screen" under the **View** menu).
* Added **User Option** for **"LogMenuInsertion"** in the bundle's _Info.plist_ to enable console logging for successful menu insertions.
* _For clarification: **User Options** have been set in a non-standard fashion inside the bundle's Info.plist instead of using NSUserDefaults because when SIMBL loads megazoomer, the reference to the mainBundle is that of the app in which it has been loaded into and not the megazoomer bundle itself. In which case, changing a 'defaults' setting applicable to megazoomer would apply only to the app in which it is currently loaded and not for all apps as desired._
* The loading of these settings first checks **~/Library/Application Support/SIMBL/Plugins/megazoomer.bundle/Contents/Info.plist** and if not found local to the current user, it searches in the system-wide location **/Library/Application Surpport/SIMBL/Plugins/...**

-------

## Documented Testing on Mac OS X 10.5.8 (PowerPC) ##

### Applications - Tested OK. ###
* **Address Book, AppleScript/Script Editor, Automator, Chess, Dictionary, Font Book, iCal, iChat, Image Capture, Mail, Preview, QuickTime Player, Safari, Stickies, TextEdit.**

### Utilities - Tested OK. ###
* **Activity Monitor, Audio MIDI Setup, Console, Directory, Disk Utility, Keychain Access, Network Utility, System Profiler, Terminal.**

### More Apple Apps - Tested OK. ### 
* **Aperture 2.1.4, Garageband 5.1, iMovie HD 6.0.4, iMovie 8.0.6, Keynote 5.0, LiveType 2.1.3, Motion 3.0.2, Numbers 2.0, Pages 4.0, Soundtrack Pro 2.0.2.**

### Developer (Xcode 3.1.4) - Tested OK. ###
* **Xcode** - Works well. The Keyboard shortcut becomes **Shift-Option-Cmd-F** due to Code Folding and View/Details commands taking precedence. To go into distraction-free full screen mode; Hide Toolbar (**Ctrl-Cmd-H**)__*__, Zoom Editor In (**Shift-Cmd-E**), double-click the dividing line for **Groups & Files** to hide the sidebar, then Enter Full Screen (**Shift-Option-Cmd-F**). You can then use Open Quickly **Shift-Cmd-D** or the Navigation Bar and the **View** -> **Go Forward**, **Go Back** and **Switch to Header/Source File** shortcuts to move around between files.
* **Interface Builder** - Works, but not recommended and introduces weirdness with Inspector window. Disabled by default.
* **Property List Editor, Dashcode, Instruments, Quartz Composer**.

__*__ On my test machine, I've edited **Keyboard Shortcuts** in **System Preferences** -> **Keyboard & Mouse** and added "Show Toolbar" and "Hide Toolbar" under **All Applications** with the Shortcut **Ctrl-Cmd-H** for both (allows toggling).

### Known Issues ###
* **iTunes 10.6.3** - Works in standard view, but minimized player zooms incorrectly.
* **Grapher** - Works, but results in an extra View menu.

### Third Party Apps - Tested OK. ###
* **Bean 3.1.1** - Also has a built-in Full Screen mode which changes the look of the editor view. Both options work well.
* **Coda 1.7.5** - Works well. Hide the Toolbar **Ctrl-Cmd-H*** and the File Browser **Ctrl-Cmd-B** for distraction-free full screen mode.
* **Espresso 1.1** - Also set shortcut for "Toggle Toolbar" in System Preferences to **Ctrl-Cmd-H** to go distraction-free.
* **Transmit 4.2**
* **WebKit r210430**

### Known not working ##
* **Finder** - Loads, but doesn't work and introduces issues with Column View and Quick Look. Disabled by default.
* **Calculator** - Incorrect zooming. Disabled by default.
* **Final Cut Pro 6.0.6**
* **TenFourFox FPR1 / 45.10.0**  - Menu insertion issues. Disabled by default (TFF has it's own Full Screen mode).
* **TextWrangler 3.5.3**
* **X11/Xquartz 2.6.3**


