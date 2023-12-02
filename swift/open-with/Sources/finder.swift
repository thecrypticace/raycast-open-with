import ScriptingBridge

///
/// A wrapper for getting  the selected items from the Finder
///
/// The current implementation takes ~6s to process almost 450 items
///
/// We should use raw apple events instead of `ScriptingBridge`
/// which is very inefficient. It sends at least one event per item
/// instead of sending a "batched" event.
///
/// The relevant event IDs are
/// - `sele` (`0x73656C65`): gets the current selected finder items
/// - `alst` (`0x616C7374`): casts a selection to an alias list
/// - `pURL` (`0x7055524C`): gets the url for a given item
///
class Finder {
  func selection() -> [URL] {
    let files = SBApplication(bundleIdentifier: "com.apple.Finder")?
      .value(forKey: "selection", asType: SBObject.self)?
      .get(asType: [SBObject].self)?
      .compactMap { $0.value(forKey: "URL", asType: String.self) }
      .compactMap { URL.init(string: $0) }

    return files ?? []
  }
}

extension SBObject {
  fileprivate func value<T>(forKey key: String, asType: T.Type) -> T? {
    value(forKey: key) as? T
  }

  fileprivate func get<T>(asType: T.Type) -> T? {
    get() as? T
  }
}
