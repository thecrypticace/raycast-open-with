import { ActionPanel, Action, List, Icon } from "@raycast/api";
import { useCachedPromise, useFrecencySorting } from "@raycast/utils";
import { useState } from "react";
import { selectedFinderItems } from "swift:../swift/open-with";

export default function Command() {
  const { data, isLoading } = useFinderSelection();

  const { files, apps, target } = {
    files: data?.files ?? [],
    apps: data?.apps ?? [],
    target: data?.files[0] ?? undefined,
  };

  const { data: sortedApps, visitItem } = useFrecencySorting(apps, {
    key: (item) => item.path,
  });

  const [searchText, setSearchText] = useState("");

  return (
    <List
      isLoading={isLoading}
      filtering={true}
      searchText={searchText}
      onSearchTextChange={setSearchText}
      searchBarPlaceholder={
        isLoading ? "Loading..." : target ? `Open "${target.name}" with...` : `Select a file in the Finder to open...`
      }
    >
      {isLoading ? null : files.length === 0 ? (
        <List.EmptyView
          icon={{ source: Icon.FountainTip }}
          title="No files selected"
          description="Select a file in the finder first"
        />
      ) : apps.length === 0 ? (
        <List.EmptyView
          icon={{ source: Icon.FountainTip }}
          title="No apps found"
          description={`No apps found that can open ${target!.name}`}
        />
      ) : (
        <>
          <List.Section title="Applications" subtitle={`${apps.length}`}>
            {sortedApps.map((app) => (
              <AppItem
                key={app.path}
                target={target!}
                app={app}
                onOpen={() => {
                  setSearchText("");
                  return visitItem(app);
                }}
              />
            ))}
          </List.Section>
        </>
      )}
    </List>
  );
}

function AppItem({ target, app, onOpen }: { app: File; target: File; onOpen?: () => void }) {
  return (
    <List.Item
      icon={{ fileIcon: app.path }}
      title={app.name}
      quickLook={{
        name: app.name,
        path: app.path,
      }}
      actions={
        <ActionPanel>
          <Action.Open
            title={`Open with ${app.name}`}
            target={target.path}
            application={app}
            icon={{ fileIcon: app.path }}
            onOpen={onOpen}
          />
        </ActionPanel>
      }
    />
  );
}

function useFinderSelection() {
  const { isLoading, data, revalidate } = useCachedPromise(() => selectedFinderItems<Selection>());

  return {
    isLoading,
    data,
    revalidate,
  };
}

interface File {
  name: string;
  path: string;
}

interface Selection {
  files: File[];
  apps: File[];
}
