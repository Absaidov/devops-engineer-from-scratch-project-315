### Hexlet tests and linter status:
[![Actions Status](https://github.com/Absaidov/devops-engineer-from-scratch-project-315/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Absaidov/devops-engineer-from-scratch-project-315/actions)

## Deployment

Install the required Ansible collections:

```bash
ansible-galaxy collection install -r requirements.yml
```

Deploy the image tag configured in `group_vars/app/vars.yml`:

```bash
make deploy
```

Deploy a new immutable image by its full Git commit SHA:

```bash
make deploy IMAGE_TAG=<full-commit-sha>
```

Roll back to a previously deployed image:

```bash
make rollback IMAGE_TAG=<previous-full-commit-sha>
```

The deployment role rejects mutable tags such as `latest`. Application data and
logs are stored on the server under `/srv/project-devops-deploy` and survive
container replacement.
