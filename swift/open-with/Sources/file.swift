import AppKit

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
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(name, forKey: .name)
    try container.encode(path, forKey: .path)
  }
}
