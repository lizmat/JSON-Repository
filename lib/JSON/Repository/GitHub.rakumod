use JSON::Repository::Helpers;

unit package JSON::Repository::GitHub;

#- JSON::Repository::GitHub::Person --------------------------------------------
class Person is Map { }
BEGIN add-simple-accessors Person, <email name username>;
BEGIN add-datetime-accessors Person, <date>;

#- JSON::Repository::GitHub::Actor --------------------------------------------
class Actor is Map { }
BEGIN add-simple-accessors Actor, <
  avatar-url email events-url followers-url following-url gists-url
  gravatar-id html-url id login name node-id organizations-url
  received-events-url repos-url site-admin starred-url subscriptions-url
  type url user-view-type
>;

#- JSON::Repository::GitHub::Commit --------------------------------------------
class Commit is Map {
    method author()    { bless-hash-as Person, self<author>    }
    method committer() { bless-hash-as Person, self<committer> }
}
BEGIN add-simple-accessors Commit, <distinct id message tree-id url>;
BEGIN add-list-accessors Commit, <added modified removed>;
BEGIN add-datetime-accessors Commit, <timestamp>;

#- JSON::Repository::GitHub::License -------------------------------------------
class License is Map { }
BEGIN add-simple-accessors License, <key name node-id spdx-id url>;

#- JSON::Repository::GitHub::Repository ----------------------------------------
class Repository is Map {
    method created-at() { DateTime.new($_)  with self<created_at> }
    method license()    { bless-hash-as License, self<license>    }
    method owner()      { bless-hash-as Actor,   self<owner>      }
    method pushed-at()  { DateTime.new($_)  with self<pushed_at>  }
}
BEGIN add-simple-accessors Repository, <
  allow-forking archive-url archived assignees-url blobs-url branches-url
  clone-url collaborators-url comments-url commits-url compare-url
  contents-url contributors-url default-branch deployment-url description
  disabled downloads-url events-url fork forks forks-count forks-url
  full-name git-commits-url git-refs-url git-tags-url git-url
  has-discussions has-downloads has-issues has-pages has-projects
  has-pull-requests has-wiki homepage hooks-url html-url id is-template
  issue-comment-url issue-events-url issues-url keys-url labels-url
  language languages-url master-branch merges-url milestones-url
  mirror-url name node-id notifications-url open-issues open-issues-count
  private pull-request-creation-policy pulls-url releases-url size
  ssh-url stargazers stargazers-count stargazers-url statuses-url
  subscribers-url subscription-url svn-url tags-url teams-url trees-url
  visibility watchers watchers-count web-commit-signoff-required
>;
BEGIN add-list-accessors Repository, <topics>;
BEGIN add-datetime-accessors Repository, <updated-at>;

#- JSON::Repository::GitHub::Push ----------------------------------------------
class Push is Map {
    method channels()    { eager (self<channels> // "").split(",")             }
    method commits()     { bless-array-elements-as Commit, self<commits> // () }
    method head-commit() { try bless-hash-as Commit,       self<head_commit>   }
    method pusher()      { bless-hash-as Person,           self<pusher>        }
    method repository()  { bless-hash-as Repository,       self<repository>    }
    method sender()      { bless-hash-as Actor,            self<sender>        }
}
BEGIN add-simple-accessors Push, <
  after base-ref before compare created deleted forced ref
>;

#- JSON::Repository::GitHub::Workflow ------------------------------------------
class Workflow is Map { }
BEGIN add-simple-accessors Workflow, <
  badge-url html-url id name node-id path state url
>;
BEGIN add-datetime-accessors Workflow, <created-at updated-at>;

#- JSON::Repository::GitHub::WorkflowRun::Run ----------------------------------
class WorkflowRun::Run is Map {
    method actor()           { bless-hash-as Actor,      self<actor>           }
    method head-commit()     { bless-hash-as Commit,     self<head-commit>     }
    method head-repository() { bless-hash-as Repository, self<head-repository> }
    method repository()      { bless-hash-as Repository, self<repository>      }
    method triggering-actor() {
        bless-hash-as Actor, self<triggering-actor>
    }
}
BEGIN add-simple-accessors WorkflowRun::Run, <
  artifacts-url cancel-url check-suite-id check-suite-node-id
  check-suite-url conclusion display-title event head-branch head-sha
  html-url id jobs-url logs-url name node-id path previous-attempt-url
  rerun-url run-attempt run-number status url workflow-id workflow-url
>;
BEGIN add-list-accessors WorkflowRun::Run, <
  pull-requests referenced-workflows
>;
BEGIN add-datetime-accessors WorkflowRun::Run, <
  created-at run-started-at updated-at
>;

#- JSON::Repository::GitHub::WorkflowRun ---------------------------------------
class WorkflowRun is Map {
    method repository()   { bless-hash-as Repository,       self<repository>   }
    method sender()       { bless-hash-as Actor,            self<sender>       }
    method workflow()     { bless-hash-as Workflow,         self<workflow>     }
    method workflow-run() { bless-hash-as WorkflowRun::Run, self<workflow-run> }
}
BEGIN add-simple-accessors WorkflowRun, <action>;

#- JSON::Repository::GitHub::WorkflowJob::Step ---------------------------------
class WorkflowJob::Step is Map { }
BEGIN add-simple-accessors WorkflowJob::Step, <
  conclusion name number status
>;
BEGIN add-datetime-accessors WorkflowJob::Step, <completed-at started-at>;

#- JSON::Repository::GitHub::WorkflowJob::WorkflowJob --------------------------
class WorkflowJob::WorkflowJob is Map {
    method steps() {
        bless-array-elements-as WorkflowJob::Step, self<steps> // ()
    }
}
BEGIN add-simple-accessors WorkflowJob::WorkflowJob, <
  check-run-url conclusion head-branch head-sha html-url id name
  node-id run-attempt run-id run-url runner-group-id runner-group-name
  runner-id runner-name status url workflow-name
>;
BEGIN add-list-accessors WorkflowJob::WorkflowJob, <labels>;
BEGIN add-datetime-accessors WorkflowJob::WorkflowJob, <
  completed-at created-at started-at
>;

#- JSON::Repository::GitHub::WorkflowJob ---------------------------------------
class WorkflowJob is Map {
    method repository() { bless-hash-as Repository, self<repository> }
    method sender()     { bless-hash-as Actor,      self<sender>     }
    method workflow()   { bless-hash-as Workflow,   self<workflow>   }
    method workflow-job() {
        bless-hash-as WorkflowJob::WorkflowJob, self<workflow-job>
    }
}
BEGIN add-simple-accessors WorkflowJob, <action>;

#- JSON::Repository::GitHub::Permissions ---------------------------------------
class Permissions is Map { }
BEGIN add-simple-accessors Permissions, <
  actions administration artifact-metadata attestations checks code-quality
  contents copilot-requests deployments discussions drives issues
  merge-queues metadata models packages pages pull-requests repository-hooks
  repository-projects security-events statuses vulnerabity-alerts
>;

#- JSON::Repository::GitHub::App -----------------------------------------------
class App is Map {
    method owner()       { bless-hash-as Actor,       self<owner>       }
    method permissions() { bless-hash-as Permissions, self<permissions> }
}
BEGIN add-simple-accessors App, <
  client-id description external-url html-url id name node-id slug
>;
BEGIN add-list-accessors App, <events>;
BEGIN add-datetime-accessors App, <created-at updated-at>;

#- JSON::Repository::GitHub::CheckSuite::CheckSuite ----------------------------
class CheckSuite::CheckSuite is Map {
    method app()         { bless-hash-as App,    self<app>         }
    method head-commit() { bless-hash-as Commit, self<head-commit> }
}
BEGIN add-simple-accessors CheckSuite::CheckSuite, <
  after before check-runs-url conclusion head-branch head-sha id
  latest-check-runs-count node-id rerequistable runs-rerequestable
  status url
>;
BEGIN add-list-accessors CheckSuite::CheckSuite, <pull-requests>;
BEGIN add-datetime-accessors CheckSuite::CheckSuite, <created-at updated-at>;

#- JSON::Repository::GitHub::CheckSuite ----------------------------------------
class CheckSuite is Map {
    method check-suite() {
        bless-hash-as CheckSuite::CheckSuite, self<check_suite>
    }
    method repository() { bless-hash-as Repository, self<repository> }
    method sender()     { bless-hash-as Actor,      self<sender>     }
}
BEGIN add-simple-accessors CheckSuite, <action>;

# vim: expandtab shiftwidth=4
