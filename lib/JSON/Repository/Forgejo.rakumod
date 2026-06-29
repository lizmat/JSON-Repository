use JSON::Repository::Helpers;

unit package JSON::Repository::Forgejo;

#- JSON::Repository::Forgejo::Person -------------------------------------------
class Person is Map { }
BEGIN add-simple-accessors Person, <email name username>;

#- JSON::Repository::Forgejo::Actor --------------------------------------------
class Actor is Map { }
BEGIN add-simple-accessors Actor, <
  active avatar-url description email followers-count following-count
  full-name html-url id is-admin language location login login-name
  prohibit-login pronouns restricted source-id starred-repos-count
  username visibility website
>;
BEGIN add-datetime-accessors Actor, <created last-login>;

#- JSON::Repository::Forgejo::Tracker ------------------------------------------
class Tracker is Map { }
BEGIN add-simple-accessors Tracker, <
  allow-only-contributors-to_track-time enable-issue-dependencies
  enable_time_tracker
>;

#- JSON::Repository::Forgejo::Permissions --------------------------------------
class Permissions is Map { }
BEGIN add-simple-accessors Permissions, <admin pull push>;

#- JSON::Repository::Forgejo::Commit -------------------------------------------
class Commit is Map {
    method author()    { bless-hash-as Person, self<author>    }
    method committer() { bless-hash-as Person, self<committer> }
}
BEGIN add-simple-accessors Commit, <id message url verification>;
BEGIN add-list-accessors Commit, <added modified removed >;
BEGIN add-datetime-accessors Commit, <timestamp>;

#- JSON::Repository::Forgejo::Repository ---------------------------------------
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

#- JSON::Repository::Forgejo::Push ---------------------------------------------
class Push is Map {
    method channels()    { eager (self<channels> // "").split(",") }
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
