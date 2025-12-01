ENV_FILE := .env

include $(ENV_FILE)
export $(shell sed 's/=.*//' $(ENV_FILE))

get-group-id:
	@./get-group-id.sh

abr apply-branch-rules:
	@./branch-rules.sh

amr apply-merge-rule:
	@./merge-rule.sh
