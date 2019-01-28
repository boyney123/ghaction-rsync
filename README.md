# GitHub Action to Deploy via `rsync` over ssh

[![GitHubActions](https://img.shields.io/badge/as%20seen%20on%20-GitHubActions-blue.svg)](https://github-actions.netlify.com/ghaction-rsync)

Sometimes, you might want to deploy static assets to some old school webserver over ssh.
This is your action.

It allows you to transfer files *from* your working directory (`/github/workspace`) *to* some server using `rsync` over ssh.
Helpfully, `/github/workspace` includes a copy of your repository *source*, as well as any build artefacts left behind by previous workflow steps (= other actions you ran before).


## Disclaimer

GitHub actions is still [in limited public beta](https://github.com/features/actions) and advises against [usage in production](https://developer.github.com/actions/).

This action in particular requires ssh private keys (see secrets), and **may be vulnerable**.
The ssh authentification **may need improvement** (see [issues](https://github.com/maxheld83/ghaction-rsync/)).


## Secrets

This action requires two secrets to authenticate over ssh:

- `SSH_PRIVATE_KEY` (you get the server you wish to deploy to)
- `SSH_PUBLIC_KEY` (you get the server you wish to deploy to)

Remember to never commit these keys, but provide them to the GitHub UI (repository settings).


## Environment Variables

This action requires three environment variables used to register the target server in `$HOME/.ssh/known_hosts`.
This is to make sure that the action is talking to a trusted server.

**`known_hosts` verification is currently overriden, see [issue 1](https://github.com/maxheld83/ghaction-rsync/issues/1)**.

- `HOST_NAME` (the name of the server you wish to deploy to, such as `foo.example.com`)
- `HOST_IP` (the IP of the server you wish to deploy to, such as `111.111.11.111`)
- `HOST_FINGERPRINT` (the fingerprint of the server you wish to deploy to, can have different formats)

The `HOST_NAME` is *also* used in the below required arguments.


## Required Arguments

`rsync` requires:

- `SRC`: source directory, relative path *from* `/github/workspace`
- `[USER@]HOST::DEST`: target user (optional), target server, and directory from root *on* that target server. 
  Remember you can reuse the environment variable `$HOST_NAME`.

For action `rsync` options, see `entrypoint.sh` in the source.
For more options and documentation on `rsync`, see [https://rsync.samba.org](https://rsync.samba.org).


## Example Usage

```
action "Deploy with rsync" {
  uses = "./"
  needs = "Write sha"
  secrets = [
    "SSH_PRIVATE_KEY",
    "SSH_PUBLIC_KEY"
  ]
  env = {
    HOST_NAME = "foo.example.com"
    HOST_IP = "111.111.11.111"
    HOST_FINGERPRINT = "ecdsa-sha2-nistp256 AAAA..."
  }
  args = [
    "$GITHUB_WORKSPACE/index.html",
    "alice@$HOST_NAME:path/to/destination"
  ]
}
```
