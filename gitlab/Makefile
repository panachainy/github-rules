ENV_FILE := .env

include $(ENV_FILE)
export $(shell sed 's/=.*//' $(ENV_FILE))

run:
	@./branch-rules.sh

group-id:
	@./get-group-id.sh
