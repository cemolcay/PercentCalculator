//
//  AppDelegate.swift
//  PercentCalc
//
//  Created by Cem Olcay on 16/09/2017.
//  Copyright © 2017 cemolcay. All rights reserved.
//

import Cocoa
import Fabric
import Crashlytics

class StatusItemView: NSView {
  var action: (() -> Void)?
  var rightAction: (() -> Void)?

  private var imageView: NSImageView?
  var image: NSImage? {
    didSet {
      if imageView == nil {
        imageView = NSImageView(frame: bounds)
        imageView?.imageScaling = .scaleProportionallyDown
        addSubview(imageView!)
      }
      imageView?.image = image
    }
  }

  override func layout() {
    super.layout()
    imageView?.frame = bounds.insetBy(dx: 2, dy: 2)
  }

  override func mouseDown(with event: NSEvent) {
    super.mouseDown(with: event)
    if event.modifierFlags.contains(.control) || event.modifierFlags.contains(.option){
      rightAction?()
    } else {
      action?()
    }
  }

  override func rightMouseDown(with event: NSEvent) {
    super.rightMouseDown(with: event)
    rightAction?()
  }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  let statusItem = NSStatusBar.system().statusItem(withLength: -2)
  let popover = NSPopover()
  var eventMonitor: EventMonitor?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Fabric
    Fabric.with([Crashlytics.self])

    // Status item
    let itemView = StatusItemView()
    itemView.action = { self.togglePopover(sender: itemView) }
    itemView.rightAction = { self.showMenu() }
    itemView.image = NSImage(named: "menuBarIcon")
    statusItem.view = itemView

    // Popover
    popover.contentViewController = NSStoryboard(name: "Main", bundle: nil)
      .instantiateController(withIdentifier: "calculator") as? ViewController

    // Event Monitor
    eventMonitor = EventMonitor(
      mask: [.leftMouseDown, .rightMouseDown],
      handler: { [weak self] event in
        guard let this = self else { return }
        if this.popover.isShown {
          this.closePopover(sender: event)
        }
    })
  }

  // MARK: Popover - Left click

  func showPopover(sender: AnyObject?) {
    eventMonitor?.start()
    if let button = statusItem.view {
      popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
  }

  func closePopover(sender: AnyObject?) {
    eventMonitor?.stop()
    popover.performClose(sender)
  }

  func togglePopover(sender: AnyObject?) {
    if popover.isShown {
      closePopover(sender: sender)
    } else {
      showPopover(sender: sender)
    }
  }

  // MARK: Menu - Right click

  func showMenu() {
    let rightMenu = NSMenu()
    rightMenu.addItem(NSMenuItem(title: "Quit", action: #selector(quitDidPress(sender:)), keyEquivalent: ""))
    statusItem.popUpMenu(rightMenu)
  }

  func quitDidPress(sender: AnyObject?) {
    NSApplication.shared().terminate(sender)
  }
}
