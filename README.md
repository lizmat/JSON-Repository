[![Actions Status](https://github.com/lizmat/JSON-RepositoryEvent/actions/workflows/linux.yml/badge.svg)](https://github.com/lizmat/JSON-RepositoryEvent/actions) [![Actions Status](https://github.com/lizmat/JSON-RepositoryEvent/actions/workflows/macos.yml/badge.svg)](https://github.com/lizmat/JSON-RepositoryEvent/actions) [![Actions Status](https://github.com/lizmat/JSON-RepositoryEvent/actions/workflows/windows.yml/badge.svg)](https://github.com/lizmat/JSON-RepositoryEvent/actions)

NAME
====

JSON::RepositoryEvent - representation of a repository event

SYNOPSIS
========

```raku
use JSON::RepositoryEvent;
my $io = "foo.json".IO;

# create from incoming request
my $new = JSON::RepositoryEvent.new(%data, request);
$io.spurt(to-json($new));

# create from existing file
my $saved = JSON::RepositoryEvent.new($io.slurp);
```

DESCRIPTION
===========

The `JSON::RepositoryEvent` provides a distribution for mapping repository related events in JSON format (such as typically provided by collaborative services such as Github / Codeberg in a webhook) into Raku classes with an object oriented interface.

All classes can be instantiated with the `.new` method and providing a correctly structured `Map` (or `Hash`). This is specifically needed when processing JSON-files that have been previously saved with the [`JSON::Webhook`](https://raku.land/zef:lizmat/JSON::Webhook) module.

CREATION FROM A WEBHOOK
=======================

The `JSON::RepositoryEvent` object can (also) be created using the information that is available inside a `Cro::HTTP::Router` route.

```raku
# create from incoming request
my $new = JSON::RepositoryEvent.new(%data, request);
```

The first argument is the data structure (usually a `Map` or a `Hash`, the second argument is the `Cro::HTTP::Request` object which contains all of the information needed.

JSON::RepositoryEvent
=====================

The `JSON::RepositoryEvent` class wraps the data from a request in the `payload` accessor: this then contains an instances of any of the other `JSON::RepositoryEvent::xxx` classes.

METHODS
-------

  * class - the type-object of the type of the payload

  * created-at - DateTime or Nil

  * headers - "key: value" of each header in the request

  * irc - list of IRC channels (named argument "irc" in request)

  * nameds - named arguments in query

  * payload - data blessed as a JSON::RepositoryEvent::xxx class

GITHUB CLASSES
==============

The full name of these classes is `JSON::RepositoryEvent::GitHub::xxx`. The `JSON::RepositoryEvent` part is not mentioned here in the documentation for convenience.

GitHub::PullRequest
-------------------

  * action - action performed

  * organization - see GitHub::Organization

  * number - pull request number

  * pull-request - see GitHub::PullRequest::PullRequest

  * repository - see GitHub::Repository

  * sender - see GitHub::Actor

GitHub::CheckRun
----------------

  * action - action performed

  * check-run - see GitHub::CheckRun::CheckRun

  * repository - see GitHub::Repository

  * sender - see GitHub::Actor

GitHub::CheckSuite
------------------

  * action - action performed

  * check-suite - see GitHub::CheckSuite::CheckSuite

  * repository - see GitHub::Repository

  * sender - see GitHub::Actor

GitHub::Fork
------------

  * forkee - see GitHub::Repository

  * repository - see GitHub::Repository

  * sender - see GitHub::Actor

GitHub::Issues
--------------

  * action - the action performed on an issue

  * issue - see GitHub::Issue

  * repository - see Forgejo::Repository

  * sender - see GitHub::Actor

GitHub::Push
------------

  * after - SHA of previous commit

  * base-ref - SHA of base reference

  * before - SHA of next commit

  * commits - list of one or more GitHub::PushCommit object

  * compare - compare URL

  * created - list of files created

  * deleted - list of files deleted

  * forced - was the push forced?

  * ref - SHA of reference

  * head-commit - see GitHub::PushCommit

  * pusher - see GitHub::Person

  * repository - see GitHub::Repository

  * sender - see GitHub::Actor

GitHub::WorkflowJob
-------------------

  * action - action performed

  * repository - see GitHub::Repository

  * sender - see GitHub::Actor

  * workflow - see GitHub::Workflow

  * workflow-job - see GitHub::WorkflowJob::WorkflowJob

GitHub::WorkflowRun
-------------------

  * action - action performed

  * repository - see GitHub::Repository

  * sender - see GitHub::Actor

  * workflow - see GitHub::Workflow

  * workflow-run - see GitHub::WorkflowRun::WorkflowRun

GITHUB ELEMENT CLASSES
======================

These classes represent (common) parts of the actual payload classes for GitHub events. The `JSON::RepositoryEvent` part is not mentioned here in the documentation for convenience.

GitHub::Actor
-------------

  * avatar-url

  * email

  * events-url

  * followers-url

  * following-url

  * gists-url

  * gravatar-id

  * html-url

  * id

  * login

  * name

  * node-id

  * organizations-url

  * received-events-url

  * repos-url

  * site-admin

  * starred-url

  * subscriptions-url

  * type

  * url

  * user-view-type

GitHub::App
-----------

  * client-id

  * created-at - DateTime

  * description

  * events - List

  * external-url

  * html-url

  * id

  * name

  * node-id

  * owner - see GitHub::Actor

  * permissions - see GitHub::Permissions

  * slug

  * update-at - DateTime

GitHub::CheckRun::CheckRun
--------------------------

  * app - see GitHub::App

  * completed-at - DateTime

  * check-suite - see GitHub::CheckSuite::CheckSuite

  * conclusion

  * details-url

  * external-id

  * head-sha

  * html-url

  * id

  * name

  * node-id

  * output - see GitHub::Output

  * pull-requests - List

  * started-at - DateTime

  * status

  * url

GitHub::CheckSuite::CheckSuite
------------------------------

  * app - see GitHub::App

  * after

  * before

  * check-runs-url

  * conclusion

  * created-at - DateTime

  * head-branch

  * head-commit - see GitHub::PushCommit

  * head-sha

  * id

  * latest-check-runs-count

  * node-id

  * pull-requests - List

  * rerequestable

  * runs-rerequestable

  * status

  * updated-at - DateTime

  * url

GitHub::Comment
---------------

  * author-association

  * body

  * commit-id

  * created-at - DateTime

  * html-url

  * id

  * line

  * node-id

  * path

  * position

  * reactions - see GitHub::Reactions

  * updated-at - DateTime

  * user - see GitHub::Actor

GitHub::Commit
--------------

  * author - see GitHub::Actor

  * comments-url

  * commit - see GitHub::PushCommit

  * committer - see GitHub::Actor

  * html-url

  * node-id

  * parents - see GitHub::Tree

  * sha

  * url

GitHub::CommitComment
---------------------

  * action

  * comment - see GitHub::Comment

  * created-at - DateTime

  * organization - see GitHub::Organization

  * repository - see GitHub::Repository

  * sender - see GitHub::Actor

  * updated-at - DateTime

GitHub::Delete
--------------

  * organization - see GitHub::Organization

  * pusher-type

  * ref

  * ref-type

  * repository - see GitHub::Repository

  * sender - see GitHub::Actor

GitHub::DependenciesSummary
---------------------------

  * blocked-by

  * blocking

  * total-blocked-by

  * total-blocking

GitHub::Issue
-------------

  * active-lock-reason

  * assignee

  * assignees - List

  * author-association

  * body

  * closed-at - DateTime

  * comments

  * comments-url

  * created-at - DateTime

  * events-url

  * html-url

  * id

  * issue-dependendencies-summary - see GitHub::DependenciesSummary

  * issue-field-values - List

  * labels - List

  * labels-url

  * locked

  * milestone

  * node-id

  * number

  * performed-via-github-app

  * pinned-comment

  * reactions - see GitHub::Reactions

  * repository-url

  * state

  * state-reason

  * timeline-url

  * updated-at - DateTime

  * url

  * user - see GitHub::Actor

GitHub::IssueComment
--------------------

  * action

  * comment - see GitHub::Comment

  * created-at - DateTime

  * issue - see GitHub::Issue

  * organization - see GitHub::Organization

  * repository - see GitHub::Repository

  * sender - see GitHub::Actor

  * updated-at - DateTime

GitHub::License
---------------

  * key

  * name

  * node-id

  * spdx-id

  * url

GitHub::Link
------------

  * href

GitHub::Organization
--------------------

  * avatar_url

  * description

  * events-url

  * hooks-url

  * id

  * issues-url

  * login

  * members-url

  * node-id

  * public-members-url

  * repos-url

  * url

GitHub::Output
--------------

  * annotations-count

  * annotations-url

  * summary

  * text

  * title

GitHub::Permissions
-------------------

  * actions

  * administration

  * artifact-metadata

  * attestations

  * checks

  * code-quality

  * contents

  * copilot-requests

  * deployments

  * discussions

  * drives

  * issues

  * merge-queues

  * metadata

  * models

  * packages

  * pages

  * pull-requests

  * repository-hooks

  * repository-projects

  * security-events

  * statuses

  * vulnerabity-alerts

GitHub::Person
--------------

  * date - DateTime

  * email

  * name

  * username

PullRequest::PullRequest
------------------------

  * _links - see GitHub::Link

  * active-lock-reason

  * additions

  * assignee

  * assignees - List

  * author-association

  * auto-merge

  * base - see GitHub::State

  * body

  * changed-files

  * closed-at - DateTime

  * comments

  * comments-url

  * commits

  * commits-url

  * created-at - DateTime

  * deletions

  * diff-url

  * draft

  * base - see GitHub::State

  * head - see GitHub::State

  * html-url

  * id

  * issue-url

  * labels - List

  * locked

  * maintainer-can-modify

  * merge-commit-sha

  * merged-at - DateTime

  * merged-by - see GitHub::Actor

  * mergeable

  * mergeable-state

  * merged

  * milestone

  * node-id

  * number

  * patch-url

  * rebaseable

  * repository - see GitHub::Repository

  * requested-reviewers - List

  * requested-teams - List

  * review-comment-url

  * review-comments

  * review-comments-url

  * sender - see GitHub::Actor

  * state

  * statuses-url

  * title

  * updated-at - DateTime

  * url

  * user - see GitHub::Actor

GitHub::PushCommit
------------------

  * added - List

  * author - see GitHub::Person

  * committer - see GitHub::Person

  * distinct

  * id

  * message

  * modified - List

  * removed - List

  * tree-id

  * timestamp - DateTime

  * url

GitHub::Reactions
-----------------

  * confused

  * eyes

  * heart

  * hooray

  * laugh

  * plus1

  * minus1

  * rocket

  * total-count

  * url

GitHub::Repository
------------------

  * allow-forking

  * archive-url

  * archived

  * assignees-url

  * blobs-url

  * branches-url

  * clone-url

  * collaborators-url

  * comments-url

  * commits-url

  * compare-url

  * contents-url

  * contributors-url

  * created-at - DateTime

  * default-branch

  * deployment-url

  * description

  * disabled

  * downloads-url

  * events-url

  * fork

  * forks

  * forks-count

  * forks-url

  * full-name

  * git-commits-url

  * git-refs-url

  * git-tags-url

  * git-url

  * has-discussions

  * has-downloads

  * has-issues

  * has-pages

  * has-projects

  * has-pull-requests

  * has-wiki

  * homepage

  * hooks-url

  * html-url

  * id

  * is-template

  * issue-comment-url

  * issue-events-url

  * issues-url

  * keys-url

  * labels-url

  * language

  * languages-url

  * license - see GitHub::License

  * master-branch

  * merges-url

  * milestones-url

  * mirror-url

  * name

  * node-id

  * notifications-url

  * open-issues

  * open-issues-count

  * owner - see GitHub::Actor

  * private

  * pull-request-creation-policy

  * pulls-url

  * pushed-at - DateTime

  * releases-url

  * size

  * ssh-url

  * stargazers

  * stargazers-count

  * stargazers-url

  * statuses-url

  * subscribers-url

  * subscription-url

  * svn-url

  * tags-url

  * teams-url

  * topics - List

  * trees-url

  * updated-at - DateTime

  * visibility

  * watchers

  * watchers-count

  * web-commit-signoff-required

GitHub::State
-------------

  * label

  * ref

  * repo - see GitHub::Repository

  * sha

  * user - see GitHub::Actor

GitHub::Status
--------------

  * avatar-url

  * brances - List

  * commit - see GitHub::TreeCommit

  * context

  * created-at - DateTime

  * description

  * id

  * name

  * organization - see GitHub::Organization

  * repository - see GitHub::Repository

  * sender - see GitHub::Actor

  * sha

  * state

  * target-url

  * updated-at - DateTime

GitHub::SubIssuesSummary
------------------------

  * complete

  * percent-completed

  * total

GitHub::Tree
------------

i=item html-url i=item sha i=item url

GitHub::TreeCommit
------------------

  * author - see GitHub::Actor

  * committer - see GitHub::Actor

  * comment-count

  * message

  * tree - see GitHub::Tree

  * url

  * verification - see GitHub::Verification

GitHub::Verification
--------------------

  * payload

  * reason

  * signature

  * verified

  * verified-at - DateTime

GitHub::Workflow
----------------

  * badge-url

  * created-at - DateTime

  * html-url

  * id

  * name

  * node-id

  * path

  * state

  * updated-at - DateTime

  * url

GitHub::WorkflowJob::WorkflowJob
--------------------------------

  * check-run-url

  * completed-at - DateTime

  * conclusion

  * created-at - DateTime

  * head-branch

  * head-sha

  * html-url

  * id

  * labels - List

  * name

  * node-id

  * run-attempt

  * run-id

  * run-url

  * runner-group-id

  * runner-group-name

  * runner-id

  * runner-name

  * started-at - DateTime

  * status

  * steps - List, see GitHub::WorkflowJob::Step

  * url

  * workflow-name

GitHub::WorkflowRun::WorkflowRun
--------------------------------

  * actor - see GitHub::Actor

  * artifacts-url

  * cancel-url

  * check-suite-id

  * check-suite-node-id

  * check-suite-url

  * conclusion

  * created-at - DateTime

  * display-title

  * event

  * head-branch

  * head-commit - see GitHub::PushCommit

  * head-sha

  * html-url

  * id

  * jobs-url

  * logs-url

  * name

  * node-id

  * path

  * previous-attempt-url

  * pull-requests -List

  * references-workflows -List

  * repository - see GitHub::Repository

  * rerun-url

  * run-attempt

  * run-number

  * run-started-at - DateTime

  * status

  * triggering-actor - see GitHub::Actor

  * updated-at - DateTime

  * url

  * workflow-id

  * workflow-url

FORGEJO CLASSES
===============

Forgejo::Fork
-------------

  * forkee - see Forgejo::Repository

  * repository - see Forgejo::Repository

  * sender - see Forgejo::Actor

Forgejo::Issues
---------------

  * action - the action performed on an issue

  * commit-id - SHA of associated commit

  * issue - see Forgejo::Issue

  * number - the issue number

  * repository - see Forgejo::Repository

  * sender - see Forgejo::Actor

Forgejo::Push
-------------

  * after - SHA of previous commit

  * before - SHA of next commit

  * commits - list of one or more Forgejo::Commit object

  * compare-url - compare URL

  * head-commit - see Forgejo::Commit

  * pusher - see Forgejo::Actor

  * ref - SHA of reference

  * repository - see Forgejo::Repository

  * sender - see Forgejo::Actor

  * total-commits - number of commits in this push

FORGEJO ELEMENT CLASSES
=======================

These classes represent (common) parts of the actual payload classes for Forgejo (Codeberg) events. The `JSON::RepositoryEvent` part is not mentioned here in the documentation for convenience.

Forgejo::Actor
--------------

  * active

  * avatar-url

  * created - DateTime

  * description

  * email

  * followers-count

  * following-count

  * full-name

  * html-url

  * id

  * is-admin

  * language

  * last-login - DateTime

  * location

  * login

  * login-name

  * prohibit-login

  * pronouns

  * restricted

  * source-id

  * starred-repos-count

  * username

  * visibility

  * website

Forgejo::Commit
---------------

  * added - List

  * author - see Forgejo::Person

  * committer - see Forgejo::Person

  * id

  * message

  * modified - List

  * removed - List

  * timestamp - DateTime

  * url

  * verification

Forgejo::Issue
--------------

  * assets - List

  * assignee

  * assignees

  * body

  * closed-at - DateTime

  * created-at - DateTime

  * comments

  * due-date

  * html-url

  * id

  * is-locked

  * labels - List

  * milestone

  * number

  * original-author

  * original-author-id

  * pin-orer

  * pull-request

  * ref

  * state

  * title

  * updated-at - DateTime

  * url

Forgejo::Permissions
--------------------

  * admin

  * pull

  * push

Forgejo::Person
---------------

  * email

  * name

  * username

Forgejo::Repository
-------------------

  * allow-fast-forward-only-merge

  * allow-merge-commits

  * allow-rebase

  * allow-rebase-explicit

  * allow-rebase-update

  * allow-squash-merge

  * archived

  * archived-at - DateTime

  * avatar-url

  * clone-url

  * created-at - DateTime

  * default-allow-maintainer-edit

  * default-branch

  * default-delete-branch-after-merge

  * default-merge-style

  * default-update-style

  * description

  * empty

  * fork

  * forks-count

  * full-name

  * globally-editable-wiki

  * has-actions

  * has-issues

  * has-projects

  * has-pull-requests

  * has-releases

  * has-wiki

  * has-wiki-contents

  * html-url

  * id

  * ignore_whitespace_conflicts

  * internal

  * internal-tracker - see Forgejo::Tracker

  * language

  * languages-url

  * link

  * mirror

  * mirror-interval

  * mirror-updated - DateTime

  * name

  * object-format

  * open-issues-count

  * open-pr-counter

  * original-url

  * owner - see Forgejo::Actor

  * permissions - see Forgejo::Permissions

  * parent

  * private

  * release-counter

  * repo-transfer

  * size

  * ssh-url

  * stars-count

  * template

  * topics - List

  * updated-at - DateTime

  * url

  * watchers-count

  * website

  * wiki-branch

  * wiki-clone-url

  * wiki-ssh-url

Forgejo::Tracker
----------------

  * allow-only-contributors-to-track-time

  * enable-issue-dependencies

  * enable_time_tracker

NAMING LOGIC
============

The data structures in the GitHub and Forgejo (e.g. Codeberg) API's typically use underscores in their names. No underscores are used in the Raku classes. If a name is mapped to a class, then an underscore created camelcase class names. So "pull_request" becomes `PullRequest` as a class name. Other fields that have an underscore map the underscores to hyphens, so "created_at" as the name of a field in the data structure, becomes "created-at" as an accessor (method name).

THEORY OF OPERATION
===================

The underlying data structure is always a `Map` (or a `Hash`). All classes are subclasses of `Map`, so all the functionality that you can expect from a `Map` can be used on any of the classes in this distribution.

All classes could be considered to be "views" on the underlying data structure: all "accessors" are in fact accessing certain parts of that data structure by key. This approach allows for fast loading: only actual parts of the data structure that need to be accessed, will be fetched on demand.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

COPYRIGHT AND LICENSE
=====================

Copyright 2026 Elizabeth Mattijsen

Source can be located at: https://codeberg.org/lizmat/JSON-RepositoryEvent . Comments and Pull Requests are welcome.

If you like this module, or what I'm doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

