# $Id: 00.load.t,v 1.2 2002/02/23 08:29:23 comdog Exp $

BEGIN { $| = 1; print "1..1\n"; }
END   { print "not ok 1\n" unless $loaded; }

use HTML::Lint;
$loaded = 1;
print "ok\n";

