use JSON::RepositoryEvent::Helpers;

unit package JSON::RepositoryEvent::Forgejo;

# Define stubs for forward references in alphabetically ordered
# list of helper classes
class Person      { ... }  # UNCOVERABLE
class Repository  { ... }  # UNCOVERABLE
class State       { ... }  # UNCOVERABLE
class Tracker     { ... }  # UNCOVERABLE

#- JSON::RepositoryEvent::Forgejo::Actor ---------------------------------------
class Actor is Map { }
BEGIN add-simple-accessors Actor, <
  active avatar-url description email followers-count following-count
  full-name html-url id is-admin language location login login-name
  prohibit-login pronouns restricted source-id starred-repos-count
  username visibility website
>;
BEGIN add-datetime-accessors Actor, <created last-login>;

#- JSON::RepositoryEvent::Forgejo::Commit --------------------------------------
class Commit is Map {
    method author()    { bless-hash-as Person, self<author>    }
    method committer() { bless-hash-as Person, self<committer> }
}
BEGIN add-simple-accessors   Commit, <id message url verification>;
BEGIN add-list-accessors     Commit, <added modified removed >;
BEGIN add-datetime-accessors Commit, <timestamp>;

#- JSON::RepositoryEvent::Forgejo::Issue ---------------------------------------
class Issue is Map {
    method repository() { bless-hash-as Repository, self<repository> }
    method user()       { bless-hash-as Actor,      self<user>       }
}
BEGIN add-simple-accessors Issue, <
  assignee assignees body comments due-date html-url id is-locked milestone
  number original-author original-author-id pin-orer pull-request ref state
  title url
>;
BEGIN add-list-accessors     Issue, <assets labels>;
BEGIN add-datetime-accessors Issue, <closed-at created-at updated-at>;

#- JSON::RepositoryEvent::Forgejo::Permissions ---------------------------------
class Permissions is Map { }
BEGIN add-simple-accessors Permissions, <admin pull push>;

#- JSON::RepositoryEvent::Forgejo::Person --------------------------------------
class Person is Map { }
BEGIN add-simple-accessors Person, <email name username>;

#- JSON::RepositoryEvent::Forgejo::PullRequest ---------------------------------
class PullRequest is Map {
    method base()       { bless-hash-as State,      self<base>       }
    method head()       { bless-hash-as State,      self<head>       }
    method merged-by()  { bless-hash-as Actor,      self<merged_by>  }
    method repository() { bless-hash-as Repository, self<repository> }
    method user()       { bless-hash-as Actor,      self<user>       }
}
BEGIN add-simple-accessors PullRequest, <
  additions allow_maintainer-edit assignee body changed-files comments
  deletions diff-url draft due-date flow html-url id issue-url is-locked
  merge-base merge-commit-sha mergeable merged milestone number patch-url
  pin-order rebaseable review-comments state title url
>;
BEGIN add-list-accessors PullRequest, <
  assignees labels requested-reviewers requested-teams
>;
BEGIN add-datetime-accessors PullRequest, <
  closed-at created-at merged-at updated-at
>;

#- JSON::RepositoryEvent::Forgejo::Repository ----------------------------------
class Repository is Map {
    method internal-tracker() {
        bless-hash-as Tracker, self<internal_tracker>
    }
    method owner()       { bless-hash-as Actor,       self<owner>       }
    method permissions() { bless-hash-as Permissions, self<permissions> }
}
BEGIN add-simple-accessors Repository, <
  allow-fast-forward-only-merge allow-merge-commits allow-rebase
  allow-rebase-explicit allow-rebase-update allow-squash-merge
  archived avatar-url clone-url default-allow-maintainer-edit
  default-branch default-delete-branch-after-merge
  default-merge-style default-update-style description empty
  fork forks-count full-name globally-editable-wiki has-actions
  has-issues has-projects has-pull-requests has-releases has-wiki
  has-wiki-contents html-url id ignore_whitespace_conflicts
  internal language languages-url link mirror mirror-interval
  name object-format open-issues-count open-pr-counter
  original-url parent private release-counter repo-transfer
  size ssh-url stars-count template url watchers-count website
  wiki-branch wiki-clone-url wiki-ssh-url
>;
BEGIN add-list-accessors Repository, <topics>;
BEGIN add-datetime-accessors Repository, <
  archived-at created-at mirror-updated updated-at
>;

#- JSON::RepositoryEvent::Forgejo::State ---------------------------------------
class State is Map {
    method repo() { bless-hash-as Repository, self<repo> }
    method user() { bless-hash-as Actor,      self<user> }
}
BEGIN add-simple-accessors State, <label ref repo-id sha>;

#- JSON::RepositoryEvent::Forgejo::Tracker -------------------------------------
class Tracker is Map { }
BEGIN add-simple-accessors Tracker, <
  allow-only-contributors-to-track-time enable-issue-dependencies
  enable_time_tracker
>;

# ⬆⬆ classes for elements of payloads
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ⬇⬇ actual payload classes

#- JSON::RepositoryEvent::Forgejo::EventCreate ------------------------------
class EventCreate is Map {
    method ^description($self) {
        my constant %description =
          branch => "A branch was created",
          tag    => "A tag was created"
        ;
        %description{$self.ref-type}
    }

    method repository() { bless-hash-as Repository, self<repository> }
    method sender()     { bless-hash-as Actor,      self<sender>     }
}
BEGIN add-simple-accessors EventCreate, <ref ref-type sha>;

#- JSON::RepositoryEvent::Forgejo::EventDelete ------------------------------
class EventDelete is Map {
    method ^description($self) {
        my constant %description =
          branch => "A branch was deleted",
          tag    => "A tag was deleted"
        ;
        %description{$self.ref-type}
    }

    method repository()   { bless-hash-as Repository,   self<repository>   }
    method sender()       { bless-hash-as Actor,        self<sender>       }
}
BEGIN add-simple-accessors EventDelete, <pusher-type ref ref-type>;

#- JSON::RepositoryEvent::Forgejo::EventFork --------------------------------
class EventFork is Map {
    method ^description($) { "A repository was forked." }

    method forkee()     { bless-hash-as Repository, self<forkee>     }
    method repository() { bless-hash-as Repository, self<repository> }
    method sender()     { bless-hash-as Actor,      self<sender>     }
}

#- JSON::RepositoryEvent::Forgejo::EventIssues ------------------------------
class EventIssues is Map {
    method ^description($self) {
        my constant %description =
          assigned      => "An issue was assigned to a user.",
          closed        => "An issue was closed.",
          deleted       => "An issue was deleted.",
          demilestoned  => "An issue was removed from a milestone.",
          edited        => "The title or body on an issue was edited.",
          field_added   => "An issue field value was set or updated on an issue.",
          field_removed => "An issue field value was cleared from an issue.",
          labeled       => "A label was added to an issue .",
          locked        => "Conversation on an issue was locked.",
          milestoned    => "An issue was added to a milestone.",
          opened        => "An issue was created.",
          pinned        => "An issue was pinned to a repository.",
          reopened      => "A previously closed issue was reopened.",
          transferred   => "An issue was transferred to another repository.",
          typed         => "An issue type was added to an issue.",
          unassigned    => "A user was unassigned from an issue.",
          unlabeled     => "A label was removed from an issue.",
          unlocked      => "Conversation on an issue was unlocked.",
          unpinned      => "An issue was unpinned from a repository.",
          untyped       => "An issue type was removed from an issue."
        ;
        %description{$self.action}
    }

    method issue()      { bless-hash-as Issue,      self<issue>      }
    method repository() { bless-hash-as Repository, self<repository> }
    method sender()     { bless-hash-as Actor,      self<sender>     }
}
BEGIN add-simple-accessors EventIssues, <action commit-id number>;

#- JSON::RepositoryEvent::Forgejo::EventPullRequest -------------------------
class EventPullRequest is Map {
    method ^description($self) {
        my constant %description =
          closed                 => "A pull request was closed.",
          edited                 => "The title or body of a pull request was edited, or the base branch of a pull request was changed.",
          labeled                => "A label was added to a pull request.",
          opened                 => "A pull request was created.",
          reopened               => "A previously closed pull request was reopened.",
          unlabeled              => "A label was removed from a pull request.",
        ;
        %description{$self.action}
    }

    method pull-request() { bless-hash-as PullRequest, self<pull_request> }
    method repository()   { bless-hash-as Repository, self<repository>    }
    method sender()       { bless-hash-as Actor,      self<sender>        }
}
BEGIN add-simple-accessors EventPullRequest, <
  action commit-id number request-reviewer review
>;

#- JSON::RepositoryEvent::Forgejo::EventPush --------------------------------
class EventPush is Map {
    method ^description($self) {
        "One or more commits have been pushed."
    }

    method commits()     { bless-array-elements-as Commit, self<commits> // () }
    method head-commit() { try bless-hash-as Commit,       self<head-commit>   }
    method pusher()      { bless-hash-as Actor,            self<pusher>        }
    method repository()  { bless-hash-as Repository,       self<repository>    }
    method sender()      { bless-hash-as Actor,            self<sender>        }
}
BEGIN add-simple-accessors EventPush, <
  after before compare-url ref total-commits
>;

# vim: expandtab shiftwidth=4
