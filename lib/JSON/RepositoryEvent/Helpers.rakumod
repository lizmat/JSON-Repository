#- helpful subroutines ---------------------------------------------------------
my sub bless-hash-as($class, \hash) is export {
    use nqp;
    nqp::istype(hash,Failure)
      ?? hash.throwl
      !! hash
        ?? nqp::p6bindattrinvres(
             nqp::create(nqp::decont($class)),
             Map,
             '$!storage',
             nqp::getattr(hash,Map,'$!storage')
           )
        !! Nil
}

my sub bless-array-elements-as($class, @array) is export {
    eager @array.map: { bless-hash-as($class, $_) }
}

my sub add-simple-accessors($class, *@method-names) is export {
    for @method-names -> $method-name {
        my $field  := $method-name.trans("-" => "_");
        my $method := my method () { self{$field} }

        $method.^set_name($method-name);
        $class.^add_method($method-name, $method);
    }
}

my sub add-datetime-accessors($class, *@method-names) is export {
    for @method-names -> $method-name {
        my $field  := $method-name.trans("-" => "_");
        my $method := my method () {
            with self{$field} {
                try DateTime.new(.contains(/^ \d+ $/) ?? +$_ !! $_)
            }
            else {
                Nil
            }
        }

        $method.^set_name($method-name);
        $class.^add_method($method-name, $method);
    }
}

my sub add-list-accessors($class, *@method-names) is export {
    for @method-names -> $method-name {
        my $field  := $method-name.trans("-" => "_");
        my $method := my method () { self{$field} // () }

        $method.^set_name($method-name);
        $class.^add_method($method-name, $method);
    }
}

# vim: expandtab shiftwidth=4
