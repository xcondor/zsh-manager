import Foundation
import Cocoa
import SwiftUI

// Required for standalone SPM executables to correctly initialize NSApplication
// and show a GUI window on macOS.

autoreleasepool {
    let app = NSApplication.shared
    app.setActivationPolicy(.regular)
    
    // Create a delegate to manage the application lifecycle
    class AppDelegate: NSObject, NSApplicationDelegate {
        var window: NSWindow?
        
        func applicationDidFinishLaunching(_ notification: Notification) {
            // Create the SwiftUI view that provides the window contents.
            let contentView = ContentView()
            
            // Create the window and set the content view.
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 1000, height: 650),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered, defer: false)
            
            window.center()
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.isMovableByWindowBackground = true
            
            window.contentView = NSHostingView(rootView: contentView)
            window.makeKeyAndOrderFront(nil)
            
            self.window = window
            
            // Set up menus for Copy/Paste support
            self.setupMenu()
            
            // Bring the app to the front
            NSApp.activate(ignoringOtherApps: true)
        }
        
        func setupMenu() {
            let mainMenu = NSMenu()
            
            // App Menu
            let appMenu = NSMenu()
            let appMenuItem = NSMenuItem()
            appMenuItem.submenu = appMenu
            appMenu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            mainMenu.addItem(appMenuItem)
            
            // Edit Menu (CRITICAL for Copy/Paste)
            let editMenu = NSMenu(title: "Edit")
            let editMenuItem = NSMenuItem()
            editMenuItem.submenu = editMenu
            
            editMenu.addItem(NSMenuItem(title: "Undo", action: #selector(UndoManager.undo), keyEquivalent: "z"))
            editMenu.addItem(NSMenuItem(title: "Redo", action: #selector(UndoManager.redo), keyEquivalent: "Z"))
            editMenu.addItem(NSMenuItem.separator())
            editMenu.addItem(NSMenuItem(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x"))
            editMenu.addItem(NSMenuItem(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c"))
            editMenu.addItem(NSMenuItem(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v"))
            editMenu.addItem(NSMenuItem(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a"))
            
            mainMenu.addItem(editMenuItem)
            NSApp.mainMenu = mainMenu
        }
        
        func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
            return true
        }
    }
    
    let delegate = AppDelegate()
    app.delegate = delegate
    app.run()
}
