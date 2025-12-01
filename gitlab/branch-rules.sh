#!/bin/bash

echo "Configuration:"
echo "  TOKEN: $TOKEN"
echo "  GROUP_ID: $GROUP_ID"
echo "  GITLAB_URL: $GITLAB_URL"
echo ""

# === Branch protection payloads ===
PROTECT_MASTER=$(cat <<EOF
{
  "name": "master",
  "push_access_level": 0,
  "merge_access_level": 40
}
EOF
)

PROTECT_DEV=$(cat <<EOF
{
  "name": "develop",
  "push_access_level": 0,
  "merge_access_level": 40
}
EOF
)

# === Allow squash commits ===
ALLOW_SQUASH_BODY=$(cat <<EOF
{
  "squash_option": "always"
}
EOF
)

echo "[*] Fetching all projects in group…"

projects=$(curl -s --header "PRIVATE-TOKEN: $TOKEN" \
  "$GITLAB_URL/api/v4/groups/$GROUP_ID/projects?per_page=100" \
  | jq -r '.[].id')

for project in $projects; do
  echo ""
  echo "[*] Updating project ID: $project"

  # Enable squash commits
  curl -s --request PUT \
    --header "PRIVATE-TOKEN: $TOKEN" \
    --header "Content-Type: application/json" \
    --data "$ALLOW_SQUASH_BODY" \
    "$GITLAB_URL/api/v4/projects/$project" >/dev/null
  echo "  - Squash commits enabled"

  # Protect master
  curl -s --request POST \
    --header "PRIVATE-TOKEN: $TOKEN" \
    --header "Content-Type: application/json" \
    --data "$PROTECT_MASTER" \
    "$GITLAB_URL/api/v4/projects/$project/protected_branches" >/dev/null
  echo "  - master protected"

  # Protect dev
  curl -s --request POST \
    --header "PRIVATE-TOKEN: $TOKEN" \
    --header "Content-Type: application/json" \
    --data "$PROTECT_DEV" \
    "$GITLAB_URL/api/v4/projects/$project/protected_branches" >/dev/null
  echo "  - dev protected"

done

echo ""
echo "[✓] Completed."
