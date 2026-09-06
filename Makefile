ANSIBLE_PLAYBOOK ?= ansible-playbook
ANSIBLE_GALAXY ?= ansible-galaxy
INVENTORY ?= inventory.ini
PREPARE_PLAYBOOK ?= playbook.yml
DEPLOY_PLAYBOOK ?= deploy.yml
IMAGE_TAG ?=

.PHONY: install prepare deploy rollback

install:
	$(ANSIBLE_GALAXY) install -r requirements.yml

prepare:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY) $(PREPARE_PLAYBOOK)

deploy:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY) $(DEPLOY_PLAYBOOK) --ask-vault-pass $(if $(IMAGE_TAG),--extra-vars "deploy_image_tag=$(IMAGE_TAG)",)

rollback:
	@test -n "$(IMAGE_TAG)" || { echo "Usage: make rollback IMAGE_TAG=<full-commit-sha>"; exit 1; }
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY) $(DEPLOY_PLAYBOOK) --ask-vault-pass --extra-vars "deploy_image_tag=$(IMAGE_TAG)"
