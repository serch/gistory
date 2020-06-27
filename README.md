# Gistory

[![Gem Version](https://badge.fury.io/rb/gistory.svg)](https://rubygems.org/gems/gistory)
[![Code Climate](https://codeclimate.com/github/serch/gistory/badges/gpa.svg)](https://codeclimate.com/github/serch/gistory)
[![Build Status](https://travis-ci.org/serch/gistory.svg?branch=master)](https://travis-ci.org/serch/gistory)
[![Coverage Status](https://coveralls.io/repos/github/serch/gistory/badge.svg?branch=master)](https://coveralls.io/github/serch/gistory?branch=master)

If you use bundler and git and you want to know when a gem was updated, `gistory` comes to the rescue, simply:

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

By default `gistory` only looks at the last 100 commits made to the current branch.
If you want to see farther back in the past run:

```shell
gistory sidekiq -m1000
```

If you want to look at all changes to Gemfile.lock in all branches, use the `-a` switch:

```shell
gistory sidekiq -a
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
- do not print the warning text if there were no more changes in the lock file
- find version with the longest length and pad all others to match it (f.i. rails has 4.2.8 and 4.2.7.1)
