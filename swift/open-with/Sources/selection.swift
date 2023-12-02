import AppKit
import Foundation
import ScriptingBridge

struct Selection {
  let files: [File]

  init(_ files: [File]) {
    self.files = files
  }

  static var current: Self {
    Self(currentlySelectedFiles())
  }

  private static func currentlySelectedFiles() -> [File] {
    let app = SBApplication(bundleIdentifier: "com.apple.Finder")!

    guard let selection = app.value(forKey: "selection") as? SBObject else {
      return []
    }

    guard let files = selection.get() as? [SBObject] else {
      return []
    }

    return files
      .compactMap { $0.value(forKey: "URL") as? String }
      .map { URL(string: $0)! }
      .map { File($0) }
  }
}

extension Selection: Encodable {
  enum CodingKeys: String, CodingKey {
    case files
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(files, forKey: .files)
  }
}
