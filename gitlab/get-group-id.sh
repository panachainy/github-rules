echo "Configuration:"
echo "GITLAB_URL: $GITLAB_URL"
echo "GROUP_NAME: $GROUP_NAME"
echo "TOKEN: $TOKEN"

# URL encode the group name (replace / with %2F)
ENCODED_GROUP_NAME=$(echo "$GROUP_NAME" | sed 's/\//%2F/g')

curl --header "PRIVATE-TOKEN: ${TOKEN}" \
  "${GITLAB_URL}/api/v4/groups?search=${ENCODED_GROUP_NAME}"
