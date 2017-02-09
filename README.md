# Gistory

If you use bundler and git, and want to know when a gem you are using was updated, `gistory` comes to your rescue, simply:

```shell
gem install gistory
cd /path/to/repo
gistory sidekiq
```

and you'll see something like:
```
Gem: sidekiq
Current version: 4.2.7

Change history:
4.2.7 on Tue,  7 Feb 2017 16:05 +01:00 (commit c6edf321)
4.2.6 on Wed, 30 Nov 2016 13:47 +01:00 (commit bf6a0d17)
4.2.5 on Tue, 22 Nov 2016 14:48 -05:00 (commit 20ff5148)
4.1.4 on Wed,  9 Nov 2016 14:31 +01:00 (commit 05a3c549)
```

By default `gistory` only looks at the 100 last changes to Gemfile.lock
if you want to see farther in the past run:

```shell
gistory sidekiq -m10000
```

Note that if the gem was added, then removed, and then added again, `gistory` will
only show the latest version changes up until it was removed.

## Roadmap

- use red for changes in the major version, blue for changes in the minor version
- support other VCSs like subversion, mercurial, etc.
- detect if the gem was added, then removed and then added again
- use a libgit2 binding instead of the git cli, how much faster it is?
- remove bundler dep
- add yard doc
