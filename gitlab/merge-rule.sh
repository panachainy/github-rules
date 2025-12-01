echo "Configuration:"
echo "  TOKEN: $TOKEN"
echo "  GROUP_ID: $GROUP_ID"
echo "  GITLAB_URL: $GITLAB_URL"
echo ""

curl --request PUT \
  --header "PRIVATE-TOKEN: $TOKEN" \
  --url "$GITLAB_URL/api/v4/groups/$GROUP_ID/merge_request_approval_settings" \
  --data-urlencode "allow_author_approval=false" \
  --data-urlencode "allow_committer_approval=false" \
  --data-urlencode "allow_overrides_to_approver_list_per_merge_request=false" \
  --data-urlencode "retain_approvals_on_push=false" \
  --data-urlencode "require_reauthentication_to_approve=true"
