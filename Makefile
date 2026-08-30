ANSIBLE_PLAYBOOK ?= ansible-playbook
INVENTORY ?= inventory.ini
DEPLOY_PLAYBOOK ?= deploy.yml
IMAGE_TAG ?=

.PHONY: deploy rollback

deploy:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY) $(DEPLOY_PLAYBOOK) --ask-vault-pass $(if $(IMAGE_TAG),--extra-vars "deploy_image_tag=$(IMAGE_TAG)",)

rollback:
	@test -n "$(IMAGE_TAG)" || { echo "Usage: make rollback IMAGE_TAG=<full-commit-sha>"; exit 1; }
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY) $(DEPLOY_PLAYBOOK) --ask-vault-pass --extra-vars "deploy_image_tag=$(IMAGE_TAG)"
