# Helm Diff Upgrade Plugin

This is a Helm plugin showing a preview of what a `helm upgrade` would change. (See [helm diff](https://github.com/databus23/helm-diff))
If there are changes detected you are prompted to proceed with the `helm upgrade` command with the same parameters.

## Installation

```shell
helm plugin install https://github.com/code-chris/helm-diff-upgrade
```

## Usage

```
Usage:
  diff-upgrade [args]
```
All `args` are redirected to the `helm diff` and `helm upgrade` commands, so you cannot use flags right now, which are only supported by one of these.
To force a upgrade when there are changes without prompt (e.g. in CI environment) set the environment variable `HELM_FORCE_DIFF_UPGRADE` to `1`.

### Example
```
Example:
  helm diff-upgrade -n monitoring grafana bitnami/grafana -f grafana.yaml

Would result in:
  helm diff upgrade -C 3 --detailed-exitcode -n monitoring grafana bitnami/grafana -f grafana.yaml
  helm upgrade -i -n monitoring grafana bitnami/grafana -f grafana.yaml
```
**Note:** The `-C 3` and `--detailed-exitcode` are hardcoded. The `helm diff` plugin is no prerequisite, its binary is downloaded internally.

### OS Support
This plugin supports Linux and MacOS environments.

## Contributing

Please refer to the [Contribution guildelines](https://github.com/ckotzbauer/.github/blob/main/CONTRIBUTING.md).

## Code of conduct

Please refer to the [Conduct guildelines](https://github.com/ckotzbauer/.github/blob/main/CODE_OF_CONDUCT.md).

## Security

Please refer to the [Security process](https://github.com/ckotzbauer/.github/blob/main/SECURITY.md).
