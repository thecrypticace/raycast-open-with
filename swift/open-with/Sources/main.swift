import AppKit
import Foundation
import ScriptingBridge
import CryptoKit
import RaycastExtensionMacro

#exportFunction(selectedFinderItems)
func selectedFinderItems() throws -> Selection {
  return Selection.current
}

#handleFunctionCall()
