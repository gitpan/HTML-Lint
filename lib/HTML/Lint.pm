#
# HTML::Lint.pm - Perl module for syntax & style checking of HTML
#

package HTML::Lint;

use strict;

use HTML::Lint::Constants;
use HTML::Lint::Messages;
use HTML::Lint::HTML4;
use IO::File;

$HTML::Lint::VERSION = "0.03";

sub new {
	my $class = shift;
	my $self  = {};

	bless $self, $class;
	$self->{msgs} = new HTML::Lint::Messages;
	$self->{html} = new HTML::Lint::HTML4;
	$self->{filename} = 'weblint';
	$self->clear_state();
	return $self;
	}

#=======================================================================
#
# check_file() - check the specified file
#
# To check a file we slurp the contents into a string, and then
# invoke the check_string() method on this.
#
#=======================================================================
sub check_file {
	my $self = shift;
	my $filename = shift;
	my $origin = shift;

	my $FILE = new IO::File("< $filename");


	if (not defined $FILE) {
		warn "unable to open $filename: $!\n";
		return undef;
	}
	local $/ = undef;
	my $string = <$FILE>;
	$FILE->close();
	$self->{filename} = $origin || $filename;
	$self->check_string($filename, $string);
}

sub strip {
	my $self = shift;
	my $string_ref = shift;
	my $length = shift;

	my $str = substr($$string_ref, 0, $length);
	$self->{line} += ($str =~ tr/\n//);
	substr($$string_ref, 0, $length) = '';
}

#=======================================================================
# check_string() - check the specified string
#=======================================================================
sub check_string {
	my $self   = shift;
	my $origin = shift;
	my $html   = shift;

	my $tag;
	my $attribute;
	my $value;
	my $content;


	$self->{line} = 1;
 OUTER:
	while ($html ne '')
	{
		#---------------------------------------------------------------
		# strip off any leading text (anything but < for now)
		#---------------------------------------------------------------
		if ($html =~ /^([^<]+)/o)
		{
		$self->{content} = $1;
		$self->strip(\$html, length($1));

		if ($self->{content} !~ /^\s*$/)
		{
		# check for illegal text context
		if (@{ $self->{tags} } > 0
			&& defined $self->{html}->{badTextContext}->{$self->{tags}->[-1]})
		{
			$self->whine('bad-text-context', $self->{tags}->[-1],
				 $self->{html}->{badTextContext}->{ $self->{tags}->[-1]});
		}

		my $lnt = $self->{content};
		while ($lnt =~ />/o)
		{
			my $nl = $lnt = $';
			my $foo;

			$nl =~ s/[^\n]//go;
			$foo = $self->{line};
			$self->{line} = $self->{line} - length($nl);
			if ('PRE' =~ /^($self->{tagRE})$/)
			{
			$self->whine('meta-in-pre', '&gt;', '>');
			}
			else
			{
			$self->whine('literal-metacharacter', '>', '&gt;');
			}
			$self->{line} = $foo;
		}
		}

		}

	$self->{content} =~ s/^\s+//;
	$self->{content} =~ s/\s+$//;
	last if $html eq '';

		#---------------------------------------------------------------
		# special case checking for <> - this shouldn't be a special case
		#---------------------------------------------------------------
	if ($html =~ m!^(<(\s*)>)!)
	{
		$self->strip(\$html, length($1));
		$self->whine('unknown-element', $2);
		next OUTER;
	}

		#---------------------------------------------------------------
		# check for whitespace after the opening <
		#---------------------------------------------------------------
		if ($html =~ m!^(<(\s*)(/?)(\s*))([^>\s]+)!o)
		{
			# print "WARNING: leading whitespace!\n";
			# $4 non-empty is error (space after / and before tag name)
			$self->{closing} = int($3 ne '');
			$self->{elt}->{tag} = $tag = uc($5);
			# $2 non-empty is an error
		$self->whine('leading-whitespace', $tag) if $2 ne '';
		$self->strip(\$html, length($1) + length($5));
		}

		#---------------------------------------------------------------
		# handle comments
	#	we don't quite handle the full definition of comments.
	#	yet.
		#---------------------------------------------------------------
	if ($tag eq '!--')
	{
		if ($html =~ /((.*?)--\s*>)/)
		{
		my $comment = $2;

		$self->strip(\$html, length($1));
		if ($comment =~ m!<[^>]+>!)
		{
			$self->whine('markup-in-comment');
		}
		}
		else
		{
		$self->whine('unclosed-comment');
		last OUTER;
		}

		#-----------------------------------------------------------
		# strip off any whitespace trailing the comment - this is
		# a hack so that we don't get tripped up thinking that
		# a container is empty when it looks like:
		#	<FOO>
		#		some text
		#		<!-- a comment -->
		#	</FOO>
		#-----------------------------------------------------------
		if ($html =~ /^(\s+)/)
		{
		$self->strip(\$html, length($1));
		}
		next OUTER;
	}

		#---------------------------------------------------------------
		# work through any attributes present, and clip through >
		#---------------------------------------------------------------
		while ($html ne '')
		{
			#-----------------------------------------------------------
			# strip off any whitespace
			#-----------------------------------------------------------
			if ($html =~ /^(\s+)/o)
			{
		$self->strip(\$html, length($1));
			}

			#-----------------------------------------------------------
			# closing >, we're done.
			#-----------------------------------------------------------
			if ($html =~ /^>/o)
			{
		$self->strip(\$html, 1);
		$self->check_tag();
		if ($self->{closing})
		{
			$self->check_closing();
		}
		else
		{
			$self->check_opening();
		}
		$self->handle_container(\$html);
		$self->{content} = '';
		$self->reset_element();
		++$self->{tagNum};
		$self->{seen_tag}->{$tag} = $self->{line};
		$self->{lastTAG} = $self->{TAG};
				next OUTER;
			}

			#-----------------------------------------------------------
			# At this point we know we have attributes,
		# check to see whether we expect to see any for this tag.
			#-----------------------------------------------------------
		$self->whine('closing-attribute', $tag) if $self->{closing};

			#-----------------------------------------------------------
			# attribute name
			#-----------------------------------------------------------
			if ($html =~ /^([^\s=>]+)/o)
			{
				$attribute = $1;
		$self->strip(\$html, length($1));
			}

			#-----------------------------------------------------------
			# attribute value
			#-----------------------------------------------------------
			if ($html =~ /^(\s*=\s*)/o)
			{
		$self->strip(\$html, length($1));
				if ($html =~ /^(")([^""]*)"/o
					|| $html =~ /^(')([^'']*)'/o)
				{
			$self->check_attribute($attribute, $2);
			if ($1 eq "'")
			{
			$self->whine('attribute-delimiter', $attribute, $tag);
			}
			$self->strip(\$html, length($2) + 2);
				}
				elsif ($html =~ /^([^\s>]+)/o)
				{
			$value = $1;
			if ($value =~ /[^-.A-Za-z0-9]/o)
			{
			$self->whine('quote-attribute-value',
					 $attribute, $value, $tag);
			}
			$self->check_attribute($attribute, $value);
			$self->strip(\$html, length($value));
				}
			}
		else
		{
		$self->check_attribute($attribute);
		}
		}
	}

	#-------------------------------------------------------------------
	# check whether we saw a FRAMESET but no NOFRAME element
	#-------------------------------------------------------------------
	if ($self->{seen_tag}->{FRAMESET} && !$self->{seen_tag}->{NOFRAMES})
	{
	$self->whine('implied-element', 'FRAMESET', 'NOFRAMES');
	}

	$self->clear_state();
}

#=======================================================================
#
# check_closing()
#
# perform checks on closing tags
#
#=======================================================================
sub check_closing {
	my $self = shift;

	my $tag  = $self->{elt}->{tag};
	my $html = $self->{html};


	#-------------------------------------------------------------------
	# for unknown elements do no further checking
	#-------------------------------------------------------------------
	$self->whine('unknown-element', $tag)
		unless (defined $html->{validAttributes}->{$tag});

	#-------------------------------------------------------------------
	#-------------------------------------------------------------------
	$self->whine('illegal-closing', $tag)
		if ($tag !~ /^($html->{pairElements})$/o);

	#-- catch empty container elements
	if ($self->{closing}
		&& $tag eq $self->{lastTAG}
		&& $self->{content} =~ /^\s*$/o
		&& $self->{tagNums}->[-1] == ($self->{tagNum} - 1)
		&& $tag ne 'TEXTAREA' && $tag ne 'TD' && $tag ne 'OBJECT') {
		$self->whine('empty-container', $tag);
	}

	$self->whine('here-anchor', $1 )
		if ($tag eq 'A' && $self->{content} =~ /^\s*(here)\s*$/io);

	#-------------------------------------------------------------------
	#-------------------------------------------------------------------
	$self->whine('title-length')
		if ($tag eq 'TITLE' && length($self->{content}) > 64);

	#-- end of HEAD, did we see a TITLE in the HEAD element? ----
	$self->whine('require-head')
		if $tag eq 'HEAD' && !$self->{seen_tag}->{'TITLE'};

	#-- was there a <LINK REV=MADE HREF="mailto:.."> element in HEAD?
	$self->whine('mailto-link')
		if $tag eq 'HEAD' && $self->{seenMailtoLink} == 0;
}

#=======================================================================
#
# whine()
#
# perform checks on closing tags
#
#=======================================================================
sub whine {
	my $self = shift;
	my $id	 = shift;
	my @argv = @_;

	$self->{msgs}->whine( $self->{filename}, $self->{line}, $id, @argv);
	}

#=======================================================================
#
# check_opening()
#
# perform checks on opening tags
#
#=======================================================================
sub check_opening {
	my $self = shift;

	my $tag  = $self->{elt}->{tag};
	my $html = $self->{html};



	#-------------------------------------------------------------------
	# For now we don't actually do anything with <!DOCTYPE ... >
	# We should take this as the version of html we're checking
	#-------------------------------------------------------------------
	if ($tag eq '!DOCTYPE') {
		$self->{seen_tag}->{'DOCTYPE'} = 1;
		return;
	}

	if (!$self->{whined}->{'require-doctype'} && !$self->{seen_tag}->{'DOCTYPE'}) {
	 	$self->whine('require-doctype');
		$self->{whined}->{'require-doctype'} = 1;
	}

	$self->whine('physical-font', $tag, $html->{physicalFontElements}->{$tag})
		if (defined $html->{physicalFontElements}->{$tag});

	$self->whine('heading-in-anchor', $tag)
		if ($tag =~ /^H[1-6]$/o && 'A' =~ /^($self->{tagRE})$/);

	$self->whine('button-usemap')
		if ($tag eq 'IMG' && exists $self->{attr}->{USEMAP} && 'BUTTON' =~ /^($self->{tagRE})$/);

	#-------------------------------------------------------------------
	# check whether all required attributes were seen
	#-------------------------------------------------------------------
	if (defined $html->{requiredAttributes}->{$tag})
		{
		foreach my $attr (split(/\|/, $html->{requiredAttributes}->{$tag})) {
			$self->whine('required-attribute', $attr, $tag)
				unless (defined $self->{attr}->{$attr});
		}
	} elsif ($tag =~ /^($html->{expectArgsRE})$/io && keys %{ $self->{attr} } == 0) {
		$self->whine('expected-attribute', $tag);
	}

	#-------------------------------------------------------------------
	# special case for empty optional container elements
	#-------------------------------------------------------------------
	if (!$self->{closing}
	&& @{ $self->{tags}} > 0
	&& $tag eq $self->{tags}->[-1]
	&& $self->{lastTAG} eq $tag
	&& $tag =~ /^($html->{maybePaired})$/
	&& $self->{tagNums}->[-1] == ($self->{tagNum} - 1)
	&& $self->{content} =~ /^\s*$/o
	&& $tag ne 'COL' && $tag ne 'COLGROUP'
	)
	{
	my $tline = $self->{line};

	pop @{ $self->{tags} }; # pop off the tag, don't care what it is
	$self->{line} = pop @{ $self->{taglines}};
	pop @{ $self->{tagNums} };
	$self->whine('empty-container', $tag);
	$self->{line} = $tline;
	$self->{tagRE} = join('|',@{ $self->{tags} });
	}

#	 if ($ID eq 'A' && defined $args{'HREF'})
#	 {
#		$target = $args{'HREF'};
#		if ($target =~ /([^:]+):\/\/([^\/]+)(.*)$/o
#	   || $target =~ /^(news|mailto):/o
#	   || $target =~ /^\//o)
#		{
#		}
#		else
#		{
#	  $target =~ s/#.*$//o;
#	  if ($target !~ /^\s*$/o && ! -f $target && ! -d $target)
#	  {
#		 &whine($., 'bad-link', $target);
#	  }
#		}
#	 }

	if ($tag =~ /^H(\d)$/o)
	{
	   if (defined $self->{heading} && $1 - $self->{heading} > 1)
	   {
	  $self->whine('heading-order', $tag, $self->{heading}, $self->{headingLine});
	  }
	   $self->{heading} 	= $1;
	   $self->{headingLine} = $self->{line};
	}

	#-- check for mailto: LINK ------------------------------
	if ($tag eq 'LINK' && defined $self->{attr}->{'REV'}
	&& defined $self->{attr}->{'HREF'}
	&& $self->{attr}->{'REV'} =~ /^made$/io
	&& $self->{attr}->{'HREF'} =~ /^mailto:/io)
	{
	$self->{seenMailtoLink} = 1;
	}


	if (defined $html->{onceOnly}->{$tag} && $self->{seen_tag}->{$tag})
	{
	   $self->whine('once-only', $tag, $self->{seen_tag}->{$tag});
	}
	$self->{seen_tag}->{$tag} = $self->{line};

	$self->whine('body-no-head') if $tag eq 'BODY' && !$self->{seen_tag}->{'HEAD'};

	if ($tag ne 'HTML' && $tag ne '!DOCTYPE' && !$self->{seen_tag}->{'HTML'}
	&& !$self->{whined}->{'outer-html'})
	{
	   $self->whine('html-outer');
	   $self->{whined}->{'outer-html'} = 1;
	}

	#-- check for illegally nested elements ---------------------
	if ($tag =~ /^($html->{nonNest})$/o && $tag =~ /^($self->{tagRE})$/) {
		my $i;

		for ($i=$#{@{ $self->{tags}}}; $self->{tags}->[$i] ne $tag; --$i)
			{
			# Nothing
			}
		$self->whine('nested-element', $tag, $self->{taglines}->[$i]);
	}


	$self->whine('unknown-element', $tag)
		unless (defined $html->{validAttributes}->{$tag});

	#-------------------------------------------------------------------
	# check for tags which have a required context
	#-------------------------------------------------------------------
	if (defined $html->{requiredContext}->{$tag})
	{
	my $ok = 0;

	foreach my $context (split(/\|/, $html->{requiredContext}->{$tag})) {
		($ok=1),last if $context =~ /^($self->{tagRE})$/;
	}
	$self->whine('required-context', $tag, $html->{requiredContext}->{$tag})
		unless $ok;
	}

	#-------------------------------------------------------------------
	# check for tags which can only appear in the HEAD element
	#-------------------------------------------------------------------
	$self->whine('head-element', $tag)
		if ($tag =~ /^($html->{headTagsRE})$/o && 'HEAD' !~ /^($self->{tagRE})$/);

	$self->whine('non-head-element', $tag)
		if (! exists $html->{okInHead}->{$tag} && 'HEAD' =~ /^($self->{tagRE})$/);

	#-------------------------------------------------------------------
	# check for use of color attributes on BODY element
	#-------------------------------------------------------------------
	if ($tag eq 'BODY') {
		my @color_attrs = @{ $html->{bodyColorAttributes} };
		my $count = 0;

		foreach my $a (@color_attrs) {
			$count++ if exists $self->{attr}->{$a};
		}
		$self->whine('body-colors', join(', ', @color_attrs))
			if ($count != 0 && $count != @color_attrs);
	}

	#-------------------------------------------------------------------
	# checks specific to the IMG element
	#-------------------------------------------------------------------
	if ($tag eq 'IMG') {
		$self->whine('img-alt') unless defined $self->{attr}->{'ALT'};
		$self->whine('img-size')
			unless defined $self->{attr}->{'WIDTH'} && defined $self->{attr}->{'HEIGHT'};
	}

	#--------------------------------------------------------
	# check for tags which have been deprecated (now obsolete)
	#--------------------------------------------------------
	$self->whine('obsolete', $tag) if $tag =~ /^($html->{obsolete})$/o;
}

#=======================================================================
#
# message_format()
#
# set the format of output message
#
#=======================================================================
sub message_format {
	my $self   = shift;
	my $format = shift;

	$self->{msgs}->message_format($format);
}

sub pedantic {
	my $self = shift;

	$self->{msgs}->pedantic();
}

sub enable {
	my $self = shift;
	my $id	 = shift;
	my $flag = shift;

	$self->{msgs}->enable($id, $flag);
	return 1;
}

#========================================================================
# Function: CheckAttributes
# Purpose:	If the tag has attributes, check them for validity.
#========================================================================
sub check_attribute {
	my $self  = shift;
	my $attr  = uc(shift);
	my $value = shift;

	my $tag  = $self->{elt}->{tag};
	my $html = $self->{html};


	return unless defined $html->{validAttributes}->{$tag};

	#-------------------------------------------------------------------
	#-------------------------------------------------------------------
	$self->whine('unknown-attribute', $tag, $attr)
		if ($attr !~ /^($html->{validAttributes}->{$tag})$/);

	#-------------------------------------------------------------------
	# catch repeated attributes.  for example:
	#	  <IMG SRC="foo.gif" SRC="bar.gif">
	#-------------------------------------------------------------------
	$self->whine('repeated-attribute', $attr, $tag)
		if (defined $self->{attr}->{$attr});

	#-------------------------------------------------------------------
	#-------------------------------------------------------------------
	$self->whine('attribute-format', $attr, $tag, $value)
		if (defined $value
			&& defined $html->{attributeFormat}->{$attr}
			&& $value !~ /^($html->{attributeFormat}->{$attr})$/i);

	#-------------------------------------------------------------------
	# remember that we've seen this attribute, and the value
	#-------------------------------------------------------------------
	$self->{attr}->{$attr} = defined $value ? $value : '';
}

#=======================================================================
#
# clear_state
#
# This clears the state information which is cached in the HTML::Lint
# instance.
#=======================================================================
sub clear_state {
	my $self = shift;


	$self->{attr}		= {};
	$self->{tags}		= [];
	$self->{orphans}		= [];
	$self->{orphanlines}	= [];
	$self->{closing}		= 0;
	$self->{content}		= '';
	$self->{tagNum} 	= 0;
	$self->{tagRE}		= '';
	$self->{lastTAG}		= '';
	$self->{seenMailtoLink} = 0;
	$self->{seen_tag}		= {};
	$self->{whined} 	= {};
	$self->{filename}		= 'weblint';
	$self->{line}		= 0;
}

sub reset_element {
	my $self = shift;

	$self->{attr}		= {};
}

#========================================================================
#
# handle_container
#
#========================================================================
sub handle_container {
	my $self = shift;
	my $page = shift;

	my $tag  = $self->{elt}->{tag};
	my $html = $self->{html};


	#-------------------------------------------------------------------
	# skip out if this isn't a container element
	#-------------------------------------------------------------------
	return if ($tag !~ /^($html->{pairElements})$/o);

	#-------------------------------------------------------------------
	# if optional container, and there is already the same element
	# on top of the stack, pop off the one there, since current
	# element closes it.
	#-------------------------------------------------------------------
	if (!$self->{closing}
	&& @{ $self->{tags} } > 0
	&& $tag eq $self->{tags}->[-1]
	&& $tag =~ /^($html->{maybePaired})$/o)
	{
	pop @{ $self->{tags}	 };
	pop @{ $self->{tagNums}  };
	pop @{ $self->{taglines} };
	$self->{tagRE} = join('|', @{ $self->{tags}});
	}

	if ($self->{closing})
	{
	#---------------------------------------------------------------
	# trailing whitespace in content of container element
	#---------------------------------------------------------------
	if (defined $self->{content}
		&& $self->{content} =~ /\S\s+$/o
		&& $tag =~ /^($html->{cuddleContainers})$/o)
	{
		$self->whine('container-whitespace', 'trailing', $tag);
	}

	#---------------------------------------------------------------
	# if we have a closing tag, and the tag(s) on top of the stack
	# are optional closing tag elements, pop tag off the stack,
	# unless it matches the current closing tag
	#---------------------------------------------------------------
	if (@{ $self->{tags}} > 0
		&& $self->{tags}->[-1] ne $tag
		&& $self->{tags}->[-1] =~ /^($html->{maybePaired})$/o
		&& ((not defined $self->{content}) || $self->{content} =~ /^\s*$/o)
		&& $self->{tagNums}->[-1] == ($self->{tagNum} - 1)
		&& $tag ne 'TD' && $tag ne 'TEXTAREA' && $tag ne 'OBJECT')
	{
		my $foo = $self->{line};

		$self->{line} = $self->{taglines}->[-1];
		$self->whine('empty-container', $self->{tags}->[-1]);
		$self->{line} = $foo;
	}

	while (@{ $self->{tags}} > 0
		   && $self->{tags}->[-1] ne $tag
		   && $self->{tags}->[-1] =~ /^($html->{maybePaired})$/o)
	{
		pop @{ $self->{tags}	 };
		pop @{ $self->{tagNums}  };
		pop @{ $self->{taglines} };
	}
	$self->{tagRE} = join('|', @{ $self->{tags} });
	}
	else
	{
	#---------------------------------------------------------------
	# leading whitespace in content of container element
	#---------------------------------------------------------------
	$self->whine('container-whitespace', 'leading', $tag)
		if ($$page =~ /^\s+/o && $tag =~ /^($html->{cuddleContainers})$/o);
	}

	if ($self->{closing} && $self->{tags}->[-1] eq $tag) {
		$self->pop_end_tag();
	} elsif ($self->{closing} && $self->{tags}->[-1] ne $tag) {
	#-- closing tag does not match opening tag on top of stack
	if ($tag =~ /^($self->{tagRE})$/)
	{
		#-----------------------------------------------------------
		# If we saw </HTML>, </HEAD>, or </BODY>, then we try
		# and resolve anything inbetween on the tag stack
		#-----------------------------------------------------------
		if ($tag =~ /^(HTML|HEAD|BODY)$/o)
		{
		while ($self->{tags}->[-1] ne $tag)
		{
			my $ttag = pop @{ $self->{tags} };

			pop @{ $self->{tagNums} };
			my $ttagline = pop @{ $self->{taglines} };
			if ($ttag !~ /^($html->{maybePaired})$/o)
			{
			$self->whine('unclosed-element', $ttag, $ttagline);
			}

			#-- does top of stack match top of orphans stack? --
			while (@{ $self->{orphans} } > 0
			   && @{$self->{tags}} > 0
			   && $self->{orphans}->[-1] eq $self->{tags}->[-1])
			{
			pop @{ $self->{orphans} 	};
			pop @{ $self->{orphanlines} };
			pop @{ $self->{tags}		};
			pop @{ $self->{tagNums} 	};
			pop @{ $self->{taglines}	};
			}
		}

		#-- pop off the HTML, HEAD, or BODY tag ------------
		pop @{ $self->{tags}};
		pop @{ $self->{tagNums}};
		pop @{ $self->{taglines}};
		$self->{tagRE} = join('|', @{ $self->{tags}});
		}
		else
		{
		#-- matched opening tag lower down on stack
		push(@{ $self->{orphans}}, $tag);
		push(@{ $self->{orphanlines}}, $self->{line});
		}
	}
	else
	{
		if ($tag =~ /^H[1-6]$/o && $self->{tags}->[-1] =~ /^H[1-6]$/o)
		{
		$self->whine('heading-mismatch', $self->{tags}->[-1], $tag);
		$self->pop_end_tag();
		}
		else
		{
		$self->whine('mis-match', $tag);
		}
	}
	}
	else
	{
	push(@{ $self->{tags}}, $tag);
	$self->{tagRE} = join('|', @{ $self->{tags}});
	push(@{ $self->{tagNums}}, $self->{tagNum});
	push(@{ $self->{taglines}}, $self->{line});
	}
}


#=======================================================================
#
# pop_end_tag
#
# we've seen a closing tag, so we want to pop the matching opener off
# the stack.
#
#=======================================================================
sub pop_end_tag
{
	my $self = shift;

	my $matched;
	my $matched_line;


	$matched	 = pop @{ $self->{tags} };
	pop @{ $self->{tagNums}};
	$matched_line = pop @{ $self->{taglines}};

	#-------------------------------------------------------------------
	# does top of stack match top of orphans stack?
	#-------------------------------------------------------------------
	while (@{ $self->{orphans}} > 0
	   && @{ $self->{tags}} > 0
	   && $self->{orphans}->[-1] eq $self->{tags}->[-1])
	{
	$self->whine('element-overlap',
			 $self->{orphans}->[-1],
			 $self->{orphanlines}->[-1],
			 $matched, $matched_line);
	pop @{ $self->{orphans} 	};
	pop @{ $self->{orphanlines} };
	pop @{ $self->{tags}		};
	pop @{ $self->{tagNums} 	};
	pop @{ $self->{taglines}	};
	}
	$self->{tagRE} = join('|', @{ $self->{tags}});
}

#=======================================================================
#
# check_tag()
#
# perform checks which we do for open and close tags.
#
#=======================================================================
sub check_tag
{
	my $self = shift;

	my $html = $self->{html};
	my $tag  = $self->{elt}->{tag};
	my $TAG;

	$TAG = $self->{TAG} = ($self->{closing} ? '/' : '').$tag;

	if (defined $html->{mustFollow}->{$TAG})
	{
	my $ok = 0;

	foreach my $pre (split(/\|/, $html->{mustFollow}->{$TAG}))
	{
	   ($ok=1),last if $pre eq $self->{lastTAG};
	}
	$self->whine('must-follow', $TAG, $html->{mustFollow}->{$TAG})
		if (!$ok || $self->{content} !~ /^\s*$/o);
	}
}

sub show_stack {
	my $self = shift;
	my @tags = @{ $self->{tags} };

	print "--STACK---------\n";
	for (my $i = $#tags; $i >= 0; --$i) {
		print "    $tags[$i]\n";
	}
	print "--END OF STACK--\n";
}

sub show_orphans {
	my $self = shift;
	my @tags = @{ $self->{orphans} };

	print "--ORPHANS---------\n";
	for (my $i = $#tags; $i >= 0; --$i) {
		print "    $tags[$i]\n";
	}
	print "--END OF ORPHANS--\n";
}

#=======================================================================
#
# set_message_handler()
#
# over-ride the function used to output messages.
#
#=======================================================================
sub set_message_handler {
	my $self = shift;
	my $func = shift;


	if ((not defined $func) || ref($func) ne 'CODE') {
		$self->whine('bogus-message-handler');
		return 0;
	}

	return $self->{msgs}->set_message_handler($func);
}

#=======================================================================
#
# messages
#
#=======================================================================
sub messages {
	my $self = shift;


	if (@_ == 0) {
		return $self->{msgs};
	} else {
		$self->{msgs} = shift;
	}
}

1;

__END__

=head1 NAME

HTML::Lint - Perl extension for checking HTML validity

=head1 SYNOPSIS

  use HTML::Lint;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for HTML::Lint, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.


=head1 AUTHOR

Andy Lester, E<lt>andy@petdance.comE<gt>, 
based on Weblint by Neil Bowers.

=head1 SEE ALSO

L<perl>.

=cut
