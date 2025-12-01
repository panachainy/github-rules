# FIXME: not work now
#!/bin/bash

echo "Configuration:"
echo "  TOKEN: $TOKEN"
echo "  GROUP_ID: $GROUP_ID"
echo "  GITLAB_URL: $GITLAB_URL"
echo ""

# === Merge request approval settings payload ===
APPROVAL_SETTINGS=$(cat <<EOF
{
  "reset_approvals_on_push": true,
  "disable_overriding_approvers_per_merge_request": true,
  "merge_requests_author_approval": false,
  "merge_requests_disable_committers_approval": true,
  "require_password_to_approve": true,
  "approvals_required": 1
}
EOF
)

echo "[*] Fetching all projects in group…"

projects=$(curl -s --header "PRIVATE-TOKEN: $TOKEN" \
  "$GITLAB_URL/api/v4/groups/$GROUP_ID/projects?per_page=100" \
  | jq -r '.[].id')


echo "Projects: $projects"

for project in $projects; do
  echo ""
  echo "[*] Updating project ID: $project"

  # Set merge request approval settings
  curl -s --request PUT \
    --header "PRIVATE-TOKEN: $TOKEN" \
    --header "Content-Type: application/json" \
    --data "$APPROVAL_SETTINGS" \
    "$GITLAB_URL/api/v4/projects/$project" >/dev/null
  echo "  - Merge request approval settings updated"

  # Create approval rule requiring 1 approval
  curl -s --request POST \
    --header "PRIVATE-TOKEN: $TOKEN" \
    --header "Content-Type: application/json" \
    --data '{"name": "Require 1 Approval", "approvals_required": 1}' \
    "$GITLAB_URL/api/v4/projects/$project/approval_rules" >/dev/null
  echo "  - Approval rule created (1 approval required)"

  # Get and display approval rules
  echo "  - Current approval rules:"
  curl -s --header "PRIVATE-TOKEN: $TOKEN" \
    "$GITLAB_URL/api/v4/projects/$project/approval_rules"

done

echo ""
echo "[✓] Completed."
