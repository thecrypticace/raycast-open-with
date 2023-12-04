import ScriptingBridge

///
/// A wrapper for getting the currently selected items from the Finder
/// Right now only returns the "first" selected item due to performance limitations with large selections
///
class Finder {
  func selection() -> [URL] {
    guard let app = SBApplication(bundleIdentifier: "com.apple.Finder") else {
      return []
    }

    guard let selection = app.value(forKey: "selection", asType: SBObject.self) else {
      return []
    }

    // TODO: selection.get() is quite slow when there are lots of Finder items selected
    // On my M3 Max it's about ~2.4s to process 500 items and this number can vary a good bit

    // Even in raw AppleScript you have to get the selection as an alias list or as text for it to not be slow
    // Need to use apple events here instead but sendEvent:id:code isn't available to Swift
    // Which means dropping ScriptingBridge entirely
    //
    // The relevant event IDs are
    // - `sele` (`0x73656C65`): gets the current selected finder items
    // - `alst` (`0x616C7374`): casts a selection to an alias list
    // - `pURL` (`0x7055524C`): gets the url for a given item (may or may not be relevant for alias lists — i have no idea)
    let array = selection.get() as? [SBObject]

    let file = array?.first
    let str = file?.value(forKey: "URL", asType: String.self)
    let url = str.flatMap { URL(string: $0) }

    guard let url else {
      return []
    }

    return [url]
  }
}

extension NSObject {
  fileprivate func value<T>(forKey key: String, asType: T.Type) -> T? {
    value(forKey: key) as? T
  }
}
