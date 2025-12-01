# Gitlab rules

## Setup access token

`https://<gitlab-url>/-/user_settings/personal_access_tokens?page=1&state=active&sort=expires_asc`

## Get group ID

`./get-group-id.sh`

## Set group ID and token in `.env` file

Create a `.env` file based on `.env.example` and fill in your `TOKEN`, `GROUP_ID`, `GITLAB_URL`, and `GROUP_NAME`.

## Run branch protection script

`make run`
