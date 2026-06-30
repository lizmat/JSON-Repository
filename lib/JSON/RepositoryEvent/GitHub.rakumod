use JSON::RepositoryEvent::Helpers;

unit package JSON::RepositoryEvent::GitHub;

# define stubs for forward references in alphabetically ordered
# list of helper classes
class Organization { ... }
class Output       { ... }
class Permissions  { ... }
class PushCommit   { ... }
class Reactions    { ... }
class Repository   { ... }
class State        { ... }
class Tree         { ... }
class TreeCommit   { ... }
class Verification { ... }

#- JSON::RepositoryEvent::GitHub::Actor ----------------------------------------
class Actor is Map { }
BEGIN add-simple-accessors Actor, <
  avatar-url email events-url followers-url following-url gists-url
  gravatar-id html-url id login name node-id organizations-url
  received-events-url repos-url site-admin starred-url subscriptions-url
  type url user-view-type
>;

#- JSON::RepositoryEvent::GitHub::App ------------------------------------------
class App is Map {
    method owner()       { bless-hash-as Actor,       self<owner>       }
    method permissions() { bless-hash-as Permissions, self<permissions> }
}
BEGIN add-simple-accessors App, <
  client-id description external-url html-url id name node-id slug
>;
BEGIN add-list-accessors     App, <events>;
BEGIN add-datetime-accessors App, <created-at updated-at>;

#- JSON::RepositoryEvent::GitHub::CheckRun::CheckRun ---------------------------
class CheckRun::CheckRun is Map {
    method app() { bless-hash-as App, self<app> }
    method check-suite() {
        bless-hash-as CheckSuite::CheckSuite, self<check_suite>
    }
    method output() { bless-hash-as Output, self<output> }
}
BEGIN add-simple-accessors CheckRun::CheckRun, <
  conclusion details-url external-id head-sha html-url id name node-id
  status url
>;
BEGIN add-list-accessors CheckRun::CheckRun, <pull-requests>;
BEGIN add-datetime-accessors CheckRun::CheckRun, <completed-at started-at>;

#- JSON::RepositoryEvent::GitHub::CheckSuite::CheckSuite -----------------------
class CheckSuite::CheckSuite is Map {
    method app()         { bless-hash-as App,        self<app>         }
    method head-commit() { bless-hash-as PushCommit, self<head-commit> }
}
BEGIN add-simple-accessors CheckSuite::CheckSuite, <
  after before check-runs-url conclusion head-branch head-sha id
  latest-check-runs-count node-id rerequistable runs-rerequestable
  status url
>;
BEGIN add-list-accessors     CheckSuite::CheckSuite, <pull-requests>;
BEGIN add-datetime-accessors CheckSuite::CheckSuite, <created-at updated-at>;

#- JSON::RepositoryEvent::GitHub::Comment --------------------------------------
class Comment is Map {
    method reactions() { bless-hash-as Reactions, self<reactions> }
    method user()      { bless-hash-as Actor,     self<user> }
}
BEGIN add-simple-accessors Comment, <
  author-association body commit-id html-url id line node-id path position 
>;
BEGIN add-datetime-accessors Comment, <created-at updated-at>;

#- JSON::RepositoryEvent::GitHub::Commit ---------------------------------------
class Commit is Map {
    method author()    { bless-hash-as Actor,          self<author>        }
    method commit()    { bless-hash-as PushCommit,     self<commit>        }
    method committer() { bless-hash-as Actor,          self<committer>     }
    method parents()   { bless-array-elements-as Tree, self<parents> // () }
}
BEGIN add-simple-accessors Commit, <comments-url html-url node-id sha url>;

#- JSON::RepositoryEvent::GitHub::CommitComment --------------------------------
class CommitComment is Map {
    method comment()      { bless-hash-as Comment,      self<comment>      }
    method organization() { bless-hash-as Organization, self<organization> }
    method repository()   { bless-hash-as Repository,   self<repository>   }
    method sender()       { bless-hash-as Actor,        self<sender>       }
}
BEGIN add-simple-accessors   CommitComment, <action>;
BEGIN add-datetime-accessors CommitComment, <created-at updated-at>;

#- JSON::RepositoryEvent::GitHub::Delete ---------------------------------------
class Delete is Map {
    method organization() { bless-hash-as Organization, self<organization> }
    method repository()   { bless-hash-as Repository,   self<repository>   }
    method sender()       { bless-hash-as Actor,        self<sender>       }
}
BEGIN add-simple-accessors Delete, <pusher-type ref ref-type>;

#- JSON::RepositoryEvent::GitHub::DependenciesSummary --------------------------
class DependenciesSummary is Map { }
BEGIN add-simple-accessors DependenciesSummary, <
  blocked-by blocking total-blocked-by total-blocking
>;

#- JSON::RepositoryEvent::GitHub::Issue ----------------------------------------
class Issue is Map {
    method issue-dependendencies-summary () {
        bless-hash-as DependenciesSummary, self<issues_dependencies_summary>
    }
    method reactions () { bless-hash-as Reactions, self<reactions> }
    method user ()      { bless-hash-as Actor,     self<user>      }
}
BEGIN add-simple-accessors Issue, <
  active-lock-reason assignee author-association body comments
  comments-url events-url html-url id labels-url locked milestone
  node-id number performed-via-github-app pinned-comment repository-url
  state state-reason timeline-url url
>;
BEGIN add-list-accessors Issue, <assignees issue-field-values labels>;
BEGIN add-datetime-accessors Issue, <closed-at created-at updated-at>;

#- JSON::RepositoryEvent::GitHub::IssueComment ---------------------------------
class IssueComment is Map {
    method comment()      { bless-hash-as Comment,      self<comment>      }
    method issue()        { bless-hash-as Issue,        self<issue>        }
    method organization() { bless-hash-as Organization, self<organization> }
    method repository()   { bless-hash-as Repository,   self<repository>   }
    method sender()       { bless-hash-as Actor,        self<sender>       }
}
BEGIN add-simple-accessors   IssueComment, <action>;
BEGIN add-datetime-accessors IssueComment, <created-at updated-at>;

#- JSON::RepositoryEvent::GitHub::License --------------------------------------
class License is Map { }
BEGIN add-simple-accessors License, <key name node-id spdx-id url>;

#- JSON::RepositoryEvent::GitHub::Link -----------------------------------------
class Link is Map { }
BEGIN add-simple-accessors Link, <href>;

#- JSON::RepositoryEvent::GitHub::Organization ---------------------------------
class Organization is Map { }
BEGIN add-simple-accessors Organization, <
  avatar_url description events-url hooks-url if issues-url login
  members-url node-id public-members-url repos-url url
>;

#- JSON::RepositoryEvent::GitHub::Output ---------------------------------------
class Output is Map { }
BEGIN add-simple-accessors Output, <
  annotations-count annotations-url summary text title
>;

#- JSON::RepositoryEvent::GitHub::Permissions ----------------------------------
class Permissions is Map { }
BEGIN add-simple-accessors Permissions, <
  actions administration artifact-metadata attestations checks code-quality
  contents copilot-requests deployments discussions drives issues
  merge-queues metadata models packages pages pull-requests repository-hooks
  repository-projects security-events statuses vulnerabity-alerts
>;

#- JSON::RepositoryEvent::GitHub::Person ---------------------------------------
class Person is Map { }
BEGIN add-simple-accessors   Person, <email name username>;
BEGIN add-datetime-accessors Person, <date>;

#- JSON::RepositoryEvent::GitHub::PullRequest::PullRequest ---------------------
class PullRequest::PullRequest is Map {
    method _links()     { bless-array-elements-as Link, self<_links>     }
    method base()       { bless-hash-as State,          self<base>       }
    method head()       { bless-hash-as State,          self<head>       }
    method merged-by()  { bless-hash-as Actor,          self<merged_by>  }
    method user()       { bless-hash-as Actor,          self<user>       }
    method repository() { bless-hash-as Repository,     self<repository> }
    method sender()     { bless-hash-as Actor,          self<sender>     }
}
BEGIN add-simple-accessors PullRequest::PullRequest, <
  active-lock-reason additions assignee author-association auto-merge
  body changed-files comments comments-url commits commits-url deletions
  diff-url draft html-url id issue-url locked maintainer-can-modify
  merge-commit-sha mergeable mergeable-state merged milestone node-id
  number patch-url rebaseable review-comment-url review-comments
  review-comments-url state statuses-url title url
>;
BEGIN add-list-accessors PullRequest::PullRequest, <
  assignees labels requested-reviewers requested-teams
>;
BEGIN add-datetime-accessors PullRequest::PullRequest, <
  closed-at created-at merged-at updated-at
>;

#- JSON::RepositoryEvent::GitHub::PushCommit ---------------------------------
# The data about a commit in a "push" payload
class PushCommit is Map {
    method author()      { bless-hash-as Person, self<author>    }
    method committer()   { bless-hash-as Person, self<committer> }
}
BEGIN add-simple-accessors   PushCommit, <distinct id message tree-id url>;
BEGIN add-list-accessors     PushCommit, <added modified removed>;
BEGIN add-datetime-accessors PushCommit, <timestamp>;

#- JSON::RepositoryEvent::GitHub::Reactions ------------------------------------
class Reactions is Map {
    method plus1()  { self<+1>  }
    method minus1() { self<-1> }
}
BEGIN add-simple-accessors Reactions, <
  confused eyes heart hooray laugh rocket total-count url
>;

#- JSON::RepositoryEvent::GitHub::Repository -----------------------------------
class Repository is Map {
    method license() { bless-hash-as License, self<license> }
    method owner()   { bless-hash-as Actor,   self<owner>   }
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
BEGIN add-list-accessors     Repository, <topics>;
BEGIN add-datetime-accessors Repository, <created-at pushed-at updated-at>;

#- JSON::RepositoryEvent::GitHub::State ----------------------------------------
class State is Map {
    method repo() { bless-hash-as Repository, self<repo> }
    method user() { bless-hash-as Actor,      self<user> }
}
BEGIN add-simple-accessors Link, <label ref sha>;

#- JSON::RepositoryEvent::GitHub::Status ---------------------------------------
class Status is Map {
    method commit()       { bless-hash-as TreeCommit,   self<commit>       }
    method organization() { bless-hash-as Organization, self<organization> }
    method repository()   { bless-hash-as Repository,   self<repository>   }
    method sender()       { bless-hash-as Actor,        self<sender>       }
}
BEGIN add-simple-accessors Status, <
  avatar-url context description id name sha state target-url
>;
BEGIN add-list-accessors     Status, <branches>;
BEGIN add-datetime-accessors Status, <created-at updated-at>;

#- JSON::RepositoryEvent::GitHub::SubIssuesSummary -----------------------------
class SubIssuesSummary is Map { }
BEGIN add-simple-accessors SubIssuesSummary, <
  complete percent-completed total
>;

#- JSON::RepositoryEvent::GitHub::Tree -----------------------------------------
class Tree is Map { }
BEGIN add-simple-accessors Tree, <html-url sha url>;

#- JSON::RepositoryEvent::GitHub::TreeCommit ---------------------------------
class TreeCommit is Map {
    method author()       { bless-hash-as Person,        self<author>      }
    method committer()    { bless-hash-as Person,        self<committer>   }
    method tree()         { bless-hash-as Tree,          self<tree>        }
    method verification() { bless-hash-as Verification, self<verification> }
}
BEGIN add-simple-accessors TreeCommit, <comment-count message url>;

#- JSON::RepositoryEvent::GitHub::Verification ---------------------------------
class Verification is Map { }
BEGIN add-simple-accessors   Verification, <payload reason signature verified>;
BEGIN add-datetime-accessors Verification, <verified_at>;

#- JSON::RepositoryEvent::GitHub::Workflow -------------------------------------
class Workflow is Map { }
BEGIN add-simple-accessors Workflow, <
  badge-url html-url id name node-id path state url
>;
BEGIN add-datetime-accessors Workflow, <created-at updated-at>;

#- JSON::RepositoryEvent::GitHub::WorkflowJob::Step ----------------------------
class WorkflowJob::Step is Map { }
BEGIN add-simple-accessors WorkflowJob::Step, <
  conclusion name number status
>;
BEGIN add-datetime-accessors WorkflowJob::Step, <completed-at started-at>;

#- JSON::RepositoryEvent::GitHub::WorkflowJob::WorkflowJob ---------------------
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

#- JSON::RepositoryEvent::GitHub::WorkflowRun::WorkflowRun ---------------------
class WorkflowRun::WorkflowRun is Map {
    method actor() {
        bless-hash-as Actor, self<actor>
    }
    method head-commit() {
        bless-hash-as PushCommit, self<head-commit>
    }
    method head-repository() {
        bless-hash-as Repository, self<head-repository>
    }
    method repository() {
        bless-hash-as Repository, self<repository>
    }
    method triggering-actor() {
        bless-hash-as Actor, self<triggering-actor>
    }
}
BEGIN add-simple-accessors WorkflowRun::WorkflowRun, <
  artifacts-url cancel-url check-suite-id check-suite-node-id
  check-suite-url conclusion display-title event head-branch head-sha
  html-url id jobs-url logs-url name node-id path previous-attempt-url
  rerun-url run-attempt run-number status url workflow-id workflow-url
>;
BEGIN add-list-accessors WorkflowRun::WorkflowRun, <
  pull-requests referenced-workflows
>;
BEGIN add-datetime-accessors WorkflowRun::WorkflowRun, <
  created-at run-started-at updated-at
>;

# ⬆⬆ classes for elements of payloads
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ⬇⬇ actual payload classes

#- JSON::RepositoryEvent::GitHub::CheckRun -------------------------------------
class CheckRun is Map {
    method ^description($self) {
        my constant %description =
          completed        => "A check run was completed, and a conclusion is available.",
          created          => "A new check run was created.",
          requested_action => "A check run completed, and someone requested a followup action that your app provides.",
          rerequested      => "Someone requested to re-run a check run."
        ;
        %description{$self.action} // "No description available";
    }

    method check-run()  { bless-hash-as CheckRun::CheckRun, self<check_run>  }
    method repository() { bless-hash-as Repository,         self<repository> }
    method sender()     { bless-hash-as Actor,              self<sender>     }
}
BEGIN add-simple-accessors CheckRun, <action>;

#- JSON::RepositoryEvent::GitHub::CheckSuite -----------------------------------
class CheckSuite is Map {
    method ^description($self) {
        my constant %description =
          completed   => "All check runs in a check suite have completed, and a conclusion is available.",
          requested   => "Someone requested to run a check suite.",
          rerequested => "Someone requested to re-run the check runs in a check suite."
        ;
        %description{$self.action} // "No description available";
    }

    method check-suite() {
        bless-hash-as CheckSuite::CheckSuite, self<check_suite>
    }
    method repository() { bless-hash-as Repository, self<repository> }
    method sender()     { bless-hash-as Actor,      self<sender>     }
}
BEGIN add-simple-accessors CheckSuite, <action>;

#- JSON::RepositoryEvent::GitHub::PullRequest ----------------------------------
class PullRequest is Map {
    method ^description($self) {
        my constant %description =
          assigned               => "A pull request was assigned to a user.",
          auto_merged_disabled   => "Auto merge was disabled for a pull request.",
          auto_merged_enabled    => "Auto merge was enabled for a pull request.",
          closed                 => "A pull request was closed.",
          converted_to_draft     => "A pull request was converted to a draft.",
          demilestoned           => "A pull request was removed from a milestone.",
          dequeued               => "A pull request was removed from the merge queue.",
          edited                 => "The title or body of a pull request was edited, or the base branch of a pull request was changed.",
          enqueued               => "A pull request was added to the merge queue.",
          labeled                => "A label was added to a pull request.",
          locked                 => "Conversation on a pull request was locked.",
          milestoned             => "A pull request was added to a milestone.",
          opened                 => "A pull request was created.",
          ready_for_review       => "A draft pull request was marked as ready for review.",
          reopened               => "A previously closed pull request was reopened.",
          review_request_removed => "A request for review by a person or team was removed from a pull request.",
          review_requested       => "Review by a person or team was requested for a pull request.",
          synchronize            => "A pull request's head branch was updated.",
          unassigned             => "A user was unassigned from a pull request.",
          unlabeled              => "A label was removed from a pull request.",
          unlocked               => "Conversation on a pull request was unlocked."
        ;
        %description{$self.action} // "No description available";
    }

    method organization() { bless-hash-as Organization, self<organization> }
    method pull-request() {
        bless-hash-as PullRequest::PullRequest, self<pull_request>
    }
    method repository() { bless-hash-as Repository, self<repository> }
    method sender()     { bless-hash-as Actor,      self<sender>     }
}
BEGIN add-simple-accessors PullRequest, <action number>;

#- JSON::RepositoryEvent::GitHub::Push -----------------------------------------
class Push is Map {
    method ^description($self) {
        "One or more commits have been pushed."
    }

    method commits() {
        bless-array-elements-as PushCommit, self<commits> // ()
    }
    method head-commit() {
        try bless-hash-as PushCommit, self<head_commit>
    }
    method pusher()     { bless-hash-as Person,     self<pusher>     }
    method repository() { bless-hash-as Repository, self<repository> }
    method sender()     { bless-hash-as Actor,      self<sender>     }
}
BEGIN add-simple-accessors Push, <
  after base-ref before compare created deleted forced ref
>;

#- JSON::RepositoryEvent::GitHub::WorkflowJob ----------------------------------
class WorkflowJob is Map {
    method ^description($self) {
        my constant %description =
          completed   => "A job in a workflow run finished.",
          in_progress => "A job in a workflow run started processing on a runner.",
          queued      => "A job in a workflow run was created.",
          waiting     => "A job in a workflow run was created and is waiting for approvals."
        ;
        %description{$self.action} // "No description available";
    }

    method repository() { bless-hash-as Repository, self<repository> }
    method sender()     { bless-hash-as Actor,      self<sender>     }
    method workflow()   { bless-hash-as Workflow,   self<workflow>   }
    method workflow-job() {
        bless-hash-as WorkflowJob::WorkflowJob, self<workflow-job>
    }
}
BEGIN add-simple-accessors WorkflowJob, <action>;

#- JSON::RepositoryEvent::GitHub::WorkflowRun ----------------------------------
class WorkflowRun is Map {
    method ^description($self) {
        my constant %description =
          completed   => "A workflow run finished.",
          in_progress => "A workflow run started processing on a runner.",
          requested   => "A workflow run was triggered."
        ;
        %description{$self.action} // "No description available";
    }

    method repository() { bless-hash-as Repository, self<repository> }
    method sender()     { bless-hash-as Actor,      self<sender>     }
    method workflow()   { bless-hash-as Workflow,   self<workflow>   }
    method workflow-run() {
        bless-hash-as WorkflowRun::WorkflowRun, self<workflow-run>
    }
}
BEGIN add-simple-accessors WorkflowRun, <action>;

# vim: expandtab shiftwidth=4
