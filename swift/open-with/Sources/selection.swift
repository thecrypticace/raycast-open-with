import Collections

struct Selection {
  let files: [File]

  init(_ files: some Sequence<File>) {
    self.files = Array(files)
  }

  var apps: some Encodable & Sequence<File> {
    guard files.count > 0 else {
      return OrderedSet()
    }

    // Returns apps in common to all selected files
    return files.reduce(into: OrderedSet(files.first!.openableBy)) { apps, file in
      apps.formIntersection(file.openableBy)
    }
  }

  static var current: Self {
    Self(
      Finder().selection().map(File.init)
    )
  }
}

extension Selection: Encodable {
  enum CodingKeys: String, CodingKey {
    case files
    case apps
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(files, forKey: .files)
    try container.encode(apps, forKey: .apps)
  }
}
