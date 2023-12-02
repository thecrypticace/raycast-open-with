import AppKit
import Foundation

/// Represents a file, folder, or application
struct File {
  private let url: URL

  init(_ url: URL) {
    self.url = url
  }

  public var name: String {
    url.deletingPathExtension().lastPathComponent
  }

  public var path: String {
    url.path
  }

  var openableBy: [Self] {
    NSWorkspace.shared.urlsForApplications(toOpen: url).map(Self.init)
  }
}

extension File: Hashable {}

extension File: Encodable {
  enum CodingKeys: String, Equatable, CodingKey {
    case name
    case path
    case openableBy
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(name, forKey: .name)
    try container.encode(path, forKey: .path)

    // Don't traverse more than one level when encoding `openableBy`
    // otherwise we'll recurse forever when encoding as this list is
    // basically never empty. If these were separate structs then
    // obviously this wouldn't be a problem and maybe I should
    // but… i don't wanna 🤣
    let fileCodingPath = encoder.codingPath.compactMap { $0 as? File.CodingKeys }
    if !fileCodingPath.contains(.openableBy) {
      try container.encode(openableBy, forKey: .openableBy)
    }
  }
}
