#!perl

use warnings;
use strict;

require 't/LintTest.pl';

checkit( [
    [ 'text-unclosed-entity' => qr/Entity &ouml; is missing its closing semicolon/ ],
], [<DATA>] );

__DATA__
<html>
    <head>
        <title>Ace of &spades;: A tribute to Mot&ouml;rhead.</title>
        <script>
            function foo() {
                if ( 6 == 9 && 25 == 6 ) {
                    x = 14;
                }
            }
        </script>
    </head>
    <body bgcolor="white">
        Mot&oumlrhead rulez!
        <p>
        Here's an awesome link to <a href="http://www.youtube.com/watch?v=8yLhA0ROGi4&feature=related">"You Better Swim"</a> from the SpongeBob movie.
        <!--
        Here in the safety of comments, we can put whatever &invalid; and &malformed entities we want, &
        nobody can stop us.  Except maybe Cheech & Chong.
        -->
    </body>
</html>
