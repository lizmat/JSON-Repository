use JSON::Repository::Forgejo;
use JSON::Repository::GitHub;
use JSON::Repository::Helpers; # bless-hash-as

#- X::JSON::Repository::Unknown-Event ------------------------------------------
class X::JSON::Repository::Unknown-Event {
    has $.type;
    has $.name;
    method message() {
        "Don't know how to handle $.type event: $.name"
    }
}

#- JSON::Repository ------------------------------------------------------------
class JSON::Repository is Map {
    method !header2class(%headers) {
        if %headers<X-Forgejo-Event> -> $event {
            my $name := $event.split("_").map(*.tc).join;
            JSON::Repository::Forgejo::{$name}:exists
              ?? JSON::Repository::Forgejo::{$name}
              !! X::JSON::Repository::Unknown-Event.new(
                   :type<Forgejo>, :$name
                 ).Failure
        }
        elsif %headers<X-GitHub-Event> -> $event {
            my $name := $event.split("_").map(*.tc).join;
            JSON::Repository::GitHub::{$name}:exists
              ?? JSON::Repository::GitHub::{$name}
              !! X::JSON::Repository::Unknown-Event.new(
                   :type<GitHub>, :$name
                 ).Failure
        }
        else {
            Nil  # ignore for now
        }
    }

    method new(%data, %headers) {
        (my $class := self!header2class(%headers)) =:= Nil
          ?? Nil
          !! bless-hash-as($class, %data)
    }
}

# vim: expandtab shiftwidth=4
