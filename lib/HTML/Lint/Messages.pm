#
# HTML::Lint::Messages
#
#

package HTML::Lint::Messages;
use 5.004;
use strict;

use HTML::Lint::Constants;

my %message_classes =
(
	'error'    => MC_ERROR,
	'warning'  => MC_WARNING,
	'style'    => MC_STYLE,
	'internal' => MC_INTERNAL,
);

my %messages =
(
 'upper-case' =>
 [
  DISABLED,
  MC_STYLE,
  'tag <$argv[0]> is not in upper case.',
  ],

 'lower-case' =>
 [
  DISABLED,
  MC_STYLE,
  'tag <$argv[0]> is not in lower case.',
  ],

 'mixed-case' =>
 [
  ENABLED,
  MC_STYLE,
  'tag case is ignored',
  ],

 'here-anchor' =>
 [
  ENABLED,
  MC_STYLE,
  'bad form to use `$argv[0]\' as anchor text!',
  ],

 'require-head' =>
 [
  ENABLED,
  MC_ERROR,
  'no <TITLE> in HEAD element.',
  ],

 'once-only' =>
 [
  ENABLED,
  MC_ERROR,
  'tag <$argv[0]> should only appear once.	I saw one on line $argv[1]!',
  ],

 'body-no-head' =>
 [
  ENABLED,
  MC_STYLE,
  '<BODY> but no <HEAD>.',
  ],

 'html-outer' =>
 [
  ENABLED,
  MC_STYLE,
  'outer tags should be <HTML> .. </HTML>.',
  ],

 'head-element' =>
 [
  ENABLED,
  MC_ERROR,
  '<$argv[0]> can only appear in the HEAD element.',
  ],

 'non-head-element' =>
 [
  ENABLED,
  MC_ERROR,
  '<$argv[0]> cannot appear in the HEAD element.',
  ],

 'obsolete' =>
 [
  ENABLED,
  MC_WARNING,
  '<$argv[0]> is obsolete.',
  ],

 'mis-match' =>
 [
  ENABLED,
  MC_ERROR,
  'unmatched </$argv[0]> (no matching <$argv[0]> seen).',
],

 'img-alt' =>
 [
  ENABLED,
  MC_WARNING,
  'IMG does not have ALT text defined.',
  ],

 'nested-element' =>
 [
  ENABLED,
  MC_ERROR,
  '<$argv[0]> cannot be nested -- </$argv[0]> not yet seen for <$argv[0]> on line $argv[1].',
  ],

 'mailto-link' =>
 [
  DISABLED,
  MC_STYLE,
  'did not see <LINK REV=MADE HREF="mailto..."> in HEAD.',
  ],

 'element-overlap' =>
 [
  ENABLED,
  MC_WARNING,
  '</$argv[0]> on line $argv[1] seems to overlap <$argv[2]>, opened on line $argv[3].',
  ],

 'unclosed-element' =>
 [
  ENABLED,
  MC_ERROR,
  'no closing </$argv[0]> seen for <$argv[0]> on line $argv[1].',
],

 'markup-in-comment' =>
 [
  ENABLED,
  MC_WARNING,
  'markup embedded in a comment can confuse some browsers.',
],

 'unknown-attribute' =>
 [
  ENABLED,
  MC_WARNING,
  'unknown attribute "$argv[1]" for element <$argv[0]>.',
  ],

 'leading-whitespace' =>
 [
  ENABLED,
  MC_WARNING,
  'should not have whitespace between "<" and "$argv[0]>".',
  ],

 'required-attribute' =>
 [
  ENABLED,
  MC_ERROR,
  'the $argv[0] attribute is required for the <$argv[1]> element.',
  ],

 'unknown-element' =>
 [
  ENABLED,
  MC_ERROR,
  'unknown element <$argv[0]>.',
  ],

 'odd-quotes' =>
 [
  ENABLED,
  MC_ERROR,
  'odd number of quotes in element <$argv[0]>.',
  ],

 'heading-order' =>
 [
  ENABLED,
  MC_STYLE,
  'bad style - heading <$argv[0]> follows <H$argv[1]> on line $argv[2].',
  ],

 'bad-link' =>
 [
  DISABLED,
  MC_WARNING,
  'target for anchor "$argv[0]" not found.',
  ],

 'expected-attribute' =>
 [
  ENABLED,
  MC_ERROR,
  'expected an attribute for <$argv[0]>.',
  ],

 'unexpected-open' =>
 [
  ENABLED,
  MC_WARNING,
  'unexpected < in <$argv[0]> -- potentially unclosed element.',
  ],

 'required-context' =>
 [
  ENABLED,
  MC_ERROR,
  'illegal context for <$argv[0]> - must appear in <$argv[1]> element.',
  ],

 'unclosed-comment' =>
 [
  ENABLED,
  MC_ERROR,
  'unclosed comment (comment should be: <!-- ... -->).',
  ],

 'illegal-closing' =>
 [
  ENABLED,
  MC_ERROR,
  'element <$argv[0]> is not a container -- </$argv[0]> not legal.',
  ],

 'extension-markup' =>
 [
  ENABLED,
  MC_WARNING,
  '<$argv[0]> is extended markup (use "-x <extension>" to allow this).',
  ],

 'extension-attribute' =>
 [
  ENABLED,
  MC_WARNING,
  'attribute "$argv[0]" for <$argv[1]> is extended markup (use "-x <extension>" to allow this).',
],

 'physical-font' =>
 [
  DISABLED,
  MC_STYLE,
  '<$argv[0]> is physical font markup -- use logical (such as $argv[1]).',
  ],

 'repeated-attribute' =>
 [
  ENABLED,
  MC_WARNING,
  'attribute $argv[0] is repeated in element <$argv[1]>',
],

 'must-follow' =>
 [
  ENABLED,
  MC_ERROR,
  '<$argv[0]> must immediately follow <$argv[1]>',
],

 'empty-container' =>
 [
  ENABLED,
  MC_WARNING,
  'empty container element <$argv[0]>.',
],

 'directory-index' =>
 [
  ENABLED,
  MC_WARNING,
  'directory $argv[0] does not have an index file ($argv[1])',
],

 'closing-attribute' =>
 [
  ENABLED,
  MC_ERROR,
  'closing tag </$argv[0]> should not have any attributes specified.',
],

 'attribute-delimiter' =>
 [
  ENABLED,
  MC_WARNING,
  'use of \' for attribute value delimiter is not supported by all browsers (attribute $argv[0] of tag $argv[1])',
  ],

 'img-size' =>
 [
  DISABLED,
  MC_WARNING,
  'setting WIDTH and HEIGHT attributes on IMG tag can improve rendering performance on some browsers.',
  ],

 'container-whitespace' =>
 [
  DISABLED,
  MC_WARNING,
  '$argv[0] whitespace in content of container element $argv[1]',
  ],

 'require-doctype' =>
 [
  DISABLED,
  MC_WARNING,
  'first element was not DOCTYPE specification',
  ],

 'literal-metacharacter' =>
 [
  ENABLED,
  MC_WARNING,
  'metacharacter "$argv[0]" should be represented as "$argv[1]"',
],

 'heading-mismatch' =>
 [
  ENABLED,
  MC_STYLE,
  'malformed heading - open tag is <$argv[0]>, but closing is </$argv[1]>',
],

 'bad-text-context' =>
 [
  ENABLED,
  MC_ERROR,
  'illegal context, <$argv[0]>, for text; should be in $argv[1].',
  ],

 'attribute-format' =>
 [
  ENABLED,
  MC_ERROR,
  'illegal value for $argv[0] attribute of $argv[1] ($argv[2])',
  ],

 'quote-attribute-value' =>
 [
  ENABLED,
  MC_ERROR,
  'value for attribute $argv[0] ($argv[1]) of element $argv[2] should be quoted (i.e. $argv[0]="$argv[1]")',
  ],

 'meta-in-pre' =>
 [
  ENABLED,
  MC_ERROR,
  'you should use "$argv[0]" in place of "$argv[1]", even in a PRE element.',
],

 'heading-in-anchor' =>
 [
  ENABLED,
  MC_ERROR,
  '<A> should be inside <$argv[0]>, not <$argv[0]> inside <A>.',
],

 'title-length' =>
 [
  ENABLED,
  MC_STYLE,
  'The HTML spec. recommends the TITLE be no longer than 64 characters.',
  ],

 'bogus-message-handler' =>
 [
  ENABLED,
  MC_INTERNAL,
  'set_message_handler() expects a function reference - handler not changed.',
  ],

  'unknown-message' =>
  [
   ENABLED,
   MC_INTERNAL,
   'unknown message identifier "$argv[0]"',
  ],

  'bad-config-file' =>
  [
   ENABLED,
   MC_INTERNAL,
   'unable to read config file `$argv[0]\': $argv[1]',
  ],

  'unknown-config-var' =>
  [
   ENABLED,
   MC_INTERNAL,
   'unknown variable `$argv[0]\' in configuration file ($argv[1])',
  ],

  'unknown-config-cmd' =>
  [
   ENABLED,
   MC_INTERNAL,
   'unknown configuration command `$argv[0]\' in configuration file ($argv[1])',
  ],

  'body-colors' =>
  [
   ENABLED,
   MC_STYLE,
   'should set all or none of $argv[0] attributes on BODY element',
  ],

  'implied-element' =>
  [
   ENABLED,
   MC_WARNING,
   'saw <$argv[0]> element, but no <$argv[1]> element',
  ],

  'button-usemap' =>
  [
   ENABLED,
   MC_ERROR,
   'illegal to associate an image map with IMG inside a BUTTON',
  ],

);

sub new
{
	my $class = shift;

	my $self  = {};


	bless $self, $class;
	$self->message_format( MF_DEFAULT );
	$self->{handle} = \*STDOUT;
	foreach my $id (keys %messages)
	{
	$self->{enabled}->{$id} = $messages{$id}->[0];
	}

	return $self;
}

sub reset_defaults
{
	my $self = shift;


	foreach my $id (keys %messages)
	{
	$self->{enabled}->{$id} = $messages{$id}->[0];
	}
}

sub message_format
{
	my $self = shift;
	my $mf	 = shift;


	$self->{'message_format'} = $mf;
}

#========================================================================
#
# whine
#
# spit out a (warning|error|style|internal) message
#
#========================================================================
sub whine
{
	my $self	 = shift;
	my $filename = shift;
	my $line	 = shift;
	my $id		 = shift;
	my @argv	 = @_;

	my $message;
	my $mf	 = $self->{'message_format'};
	my $fh	 = $self->{handle};


	return unless $self->{enabled}->{$id} == ENABLED;

	$message = $messages{$id}->[2];
	$message =~ s/\$argv\[(\d+)\]/$argv[$1]/ge;

	#-------------------------------------------------------------------
	# has a custom message handler been registered?
	#-------------------------------------------------------------------
	if (defined $self->{whine})
	{
	my $func = $self->{whine};
	&$func($filename, $line, $id, $message, @argv);
	return;
	}

	#-------------------------------------------------------------------
	# if no custom handler, output according to message style
	#-------------------------------------------------------------------

	if ($mf == MF_TERSE)
	{
	print $fh "$filename:$line:$id\n";
	}
	elsif ($mf == MF_LINT)
	{
	print $fh "$filename($line): $message\n";
	}
	elsif ($mf == MF_SHORT)
	{
	print $fh "line $line: $message\n";
	}
}

#========================================================================
#
# enable()
#
# Takes a warning identifier and an integer (boolean) flag which
# specifies whether the warning should be enabled.
#
#========================================================================
sub enable
{
	my $self = shift;
	my $id	 = shift;
	my $flag = shift;

	my $ref;
	my @keys;


	#-------------------------------------------------------------------
	# Is the id one of the meta ids, for the four message classes?
	#-------------------------------------------------------------------
	if (exists $message_classes{$id})
	{
	$self->class_enable($message_classes{$id}, $flag);
	return;
	}

	if (! exists $self->{enabled}->{$id})
	{
	$self->whine('weblint', '*', 'unknown-message', $id);
	return 0;
	}

	$self->{enabled}->{$id} = $flag;

	#
	# ensure consistency: if you just enabled upper-case,
	# then we should make sure that lower-case is disabled
	#
	$self->{enabled}->{'lower-case'} = DISABLED if $id eq 'upper-case';
	$self->{enable}->{'upper-case'} = DISABLED if $id eq 'lower-case';
	if ($id eq 'mixed-case')
	{
	$self->enable('upper-case', DISABLED);
	$self->enable('lower-case', DISABLED);
	}

	return 1;
}

#========================================================================
#
# class_enable
#
#========================================================================
sub class_enable
{
	my $self		  = shift;
	my $message_class = shift;
	my $flag		  = shift;

	my $id;
	my $values;


	while (($id, $values) = each %messages)
	{
	if ($values->[1] == $message_class)
	{
		$self->enable($id, $flag);
	}
	}
}

#=======================================================================
#
# output_handle
#
# query or set the file handle which we write messages to
# return the previous file handle, or the current file handle
# if called without argument.
#
#=======================================================================
sub output_handle
{
	my $self = shift;

	my $handle = $self->{handle};


	if (@_ > 0)
	{
	$self->{handle} = shift;
	}

	return $handle;
}

#=======================================================================
#
# pedantic
#
# pedantic command-line switch turns on all warnings except case checking
#
#=======================================================================
sub pedantic
{
	my $self = shift;


	foreach my $warning (keys %messages)
	{
	$self->enable($warning, ENABLED);
	}
	$self->enable('lower-case', 	 DISABLED);
	$self->enable('upper-case', 	 DISABLED);
	$self->enable('bad-link',		 DISABLED);
	$self->enable('require-doctype', DISABLED);
}

#=======================================================================
#
# set_message_handler
#
#=======================================================================
sub set_message_handler
{
	my $self = shift;
	my $func = shift;


	$self->{whine} = $func;
	return 1;
}

#=======================================================================
#
# list_messages
#
#=======================================================================
sub list_messages
{
	my $self = shift;

	my $handle = $self->{handle};
	my $text;
	my $id;


	foreach $id (keys %messages)
	{
	$text = $messages{$id}->[2];
	$text =~ s/\$argv\[(\d+)\]/.../g;
	print $handle "$id (",
					  ($self->{enabled}->{$id} == ENABLED ? 'enabled' : 'disabled'), ")\n",
					  "    $text\n\n";
	}
}

1;

__END__

=head1 NAME

HTML::Lint::Messages - perl module encapsulating weblint output messages

=head1 SYNOPSIS

	use HTML::Lint::Messages;

	my $msg = HTML::Lint::Messages->new();
	$msg->whine('title-length');

=head1 DESCRIPTION

B<HTML::Lint::Messages> is a class which provides access to the messages
output by weblint (warnings, error messages, and stylistic comments).

By default this module is used by the B<HTML::Lint> module,
so unless you're doing something fancy, you don't need to know
about it.

=head1 METHODS

=head2 CONSTRUCTOR

The constructor doesn't take any arguments, so is used as follows:

	use HTML::Lint::Messages;
	
	$messages = HTML::Lint::Messages->new();

=head2 whine

Generate an output message:

	$messages->whine( ID, argument1 ... argumentN );

The first argument is a string which identifies the message.
This is followed by zero or more message-specific arguments,
which get interpolated into the message.

=head2 reset_defaults

This method will reset the configuration of the module to the defaults
built in:

	$messages = HTML::Lint::Messages->new();
	... do some things ...
	$messages->reset_defaults();

=head2 message_format

Set the format of message which will be output:

	$messages->message_format( MF_TERSE );

There are three message formats currently supported.
The identifiers for the three formats are defined
in the B<HTML::Lint::Constants> module. The three message formats are:

=over 4

=item MF_LINT

This is the standard lint format, which is used by default.
The format is:

	filename(line): message

=item MF_TERSE

This is meant mainly for automatic processing of weblint output;
the format is:

	filename:line:message

=item MF_SHORT

This is a shortened format, which doesn't include the filename.
It is useful in places where the filename is temporary:

	line N: message

=back

=head2 enable

=head2 class_enable

=head2 output_handle

Set the filehandle which messages should be written to.

	$messages = HTML::Lint::Messages->new();
	$FILE = new IO::File("> file.out");
	$old = $messages->output_handle($FILE);

This method returns the previous filehandle.
The method can be used without any argument to query the
current filehandle.

	$cur_handle = $messages->output_handle();

By default this is set to standard output (STDOUT).

=head2 class_enable

=head2 pedantic

Hmm, just thought, this should be a meta class. Maybe should have
flags, so you can enable (PEDANTIC | INTERNAL).

OK, this method is likely to go away :-)

=head2 set_message_handler

=head1 SEE ALSO

=over 4

=item HTML::Lint

The weblint module.

=item http://www.weblint.org/

The weblint web site, where you can always get the latest
version of weblint.

=back

=head1 AUTHOR

Andy Lester E<lt>andy@petdance.comE<gt>

=head1 COPYRIGHT

Copyright (c) Andy Lester 2001. All Rights Reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

