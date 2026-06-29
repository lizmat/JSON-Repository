use JSON::RepositoryEvent::Helpers;

unit package JSON::RepositoryEvent::Forgejo;

#- JSON::RepositoryEvent::Forgejo::Person --------------------------------------
class Person is Map { }
BEGIN add-simple-accessors Person, <email name username>;

#- JSON::RepositoryEvent::Forgejo::Actor ---------------------------------------
class Actor is Map { }
BEGIN add-simple-accessors Actor, <
  active avatar-url description email followers-count following-count
  full-name html-url id is-admin language location login login-name
  prohibit-login pronouns restricted source-id starred-repos-count
  username visibility website
>;
BEGIN add-datetime-accessors Actor, <created last-login>;

#- JSON::RepositoryEvent::Forgejo::Tracker -------------------------------------
class Tracker is Map { }
BEGIN add-simple-accessors Tracker, <
  allow-only-contributors-to_track-time enable-issue-dependencies
  enable_time_tracker
>;

#- JSON::RepositoryEvent::Forgejo::Permissions ---------------------------------
class Permissions is Map { }
BEGIN add-simple-accessors Permissions, <admin pull push>;

#- JSON::RepositoryEvent::Forgejo::Commit --------------------------------------
class Commit is Map {
    method author()    { bless-hash-as Person, self<author>    }
    method committer() { bless-hash-as Person, self<committer> }
}
BEGIN add-simple-accessors   Commit, <id message url verification>;
BEGIN add-list-accessors     Commit, <added modified removed >;
BEGIN add-datetime-accessors Commit, <timestamp>;

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

#- JSON::RepositoryEvent::Forgejo::Issues --------------------------------------
class Issues is Map {
    method issue()      { bless-hash-as Issue,      self<issue>      }
    method repository() { bless-hash-as Repository, self<repository> }
    method sender()     { bless-hash-as Actor,      self<sender>     }
}
BEGIN add-simple-accessors Issues, <
  action commit-id number
>;

#- JSON::RepositoryEvent::Forgejo::Push ----------------------------------------
class Push is Map {
    method ^description($self) {
        "One or more commits have been pushed."
    }

    method commits()     { bless-array-elements-as Commit, self<commits> // () }
    method head-commit() { try bless-hash-as Commit,       self<head-commit>   }
    method pusher()      { bless-hash-as Actor,            self<pusher>        }
    method repository()  { bless-hash-as Repository,       self<repository>    }
    method sender()      { bless-hash-as Actor,            self<sender>        }
}
BEGIN add-simple-accessors Push, <
  after before compare-url ref total-commits
>;

# vim: expandtab shiftwidth=4
