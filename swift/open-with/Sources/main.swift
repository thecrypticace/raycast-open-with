import RaycastExtensionMacro

#exportFunction(selectedFinderItems)
func selectedFinderItems() throws -> Selection {
  return Selection.current
}

#handleFunctionCall()
