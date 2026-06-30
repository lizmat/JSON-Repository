use JSON::RepositoryEvent::Forgejo;
use JSON::RepositoryEvent::GitHub;
use JSON::RepositoryEvent::Helpers; # bless-hash-as

#- X::JSON::RepositoryEvent::Unknown -------------------------------------------
class X::JSON::RepositoryEvent::Unknown is Exception {
    has $.type;
    has $.name;
    method message() {
        "Don't know how to handle $.type event: $.name"
    }
}

#- JSON::RepositoryEvent -------------------------------------------------------
class JSON::RepositoryEvent is Map {
    method !header2class(@headers) {
        if @headers.first(*.name eq 'X-Forgejo-Event') -> $event {
            my $name := $event.value.split("_").map(*.tc).join;
            JSON::RepositoryEvent::Forgejo::{$name}:exists
              ?? JSON::RepositoryEvent::Forgejo::{$name}
              !! X::JSON::RepositoryEvent::Unknown.new(
                   :type<Forgejo>, :$name
                 ).Failure
        }
        elsif @headers.first(*.name eq 'X-GitHub-Event') -> $event {
            my $name := $event.value.split("_").map(*.tc).join;
            JSON::RepositoryEvent::GitHub::{$name}:exists
              ?? JSON::RepositoryEvent::GitHub::{$name}
              !! X::JSON::RepositoryEvent::Unknown.new(
                   :type<GitHub>, :$name
                 ).Failure
        }
        else {
            Nil  # ignore for now
        }
    }

    proto method new(|) {*}
    multi method new(\data) {
        bless-hash-as(self, data)
    }
    multi method new(\payload, $request) {
        self.new(payload, $request.headers, $request.query-hash);
    }

    multi method new(
      \payload, @headers, %nameds
    ) is implementation-detail {
        (my $class := self!header2class(@headers)) =:= Nil
          ?? Nil
          !! bless-hash-as(self, my % is Map =
               :class($class.^name),
               :created_at(DateTime.now.Str),
               :headers(eager @headers.map({ "$_.name(): $_.value()" })),
               :%nameds,
               :payload(bless-hash-as($class, payload))
             )
    }

    # accessors
    method class()      {                        ::(self<class>)        }
    method created-at() {              DateTime.new(self<created_at>)   }
    method headers()    {                           self<headers> // () }
    method irc          { eager (self.nameds<irc> // "").split(",")     }
    method nameds()     {                           self<nameds>  // {} }
    method payload()    { bless-hash-as self.class, self<payload>       }

    # utility methods
    method description() { self.payload.^description }
}

# vim: expandtab shiftwidth=4
