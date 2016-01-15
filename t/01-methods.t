#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;
use Test::Exception;

use_ok 'Array::RealSpan';

my $span = Array::RealSpan->new;
isa_ok $span, 'Array::RealSpan';

lives_ok { $span->set_range( 0, 1, 'A' ) } 'lives through set_range A';
is $span->lookup(0), 'A', 'lookup A';
ok !$span->lookup(1), 'lookup fail';

lives_ok { $span->set_range( 1, 5.5, 'B' ) } 'lives through set_range B';
is $span->lookup(1.5), 'B', 'lookup B';

is_deeply $span->get_range('A'), [0,1], 'get_range A';

done_testing();
