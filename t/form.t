#!/usr/local/bin/perl -w
#
# html4.t - basic weblint tests for HTML 4 features
#
# Copyright (C) 1995-1999 Neil Bowers.  All rights reserved.
#
# See README for additional blurb.
# Bugs, comments, suggestions welcome: neilb@weblint.org
#
# $Id: form.t,v 1.4 1999/04/07 22:45:17 neilb Exp $
#

use lib qw( . t/ );
use LintTest qw(run_tests);
use strict;

run_tests();

exit 0;

#============================================================================
#============================================================================

__END__
not allowed to nest FORM elements
####
<HTML>
<HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<FORM METHOD=post ACTION="http://www.cre.canon.co.uk/foo">
<FORM METHOD=post ACTION="http://www.cre.canon.co.uk/foo">
This is inside the nested form
</FORM>
</FORM></BODY></HTML>
####
5:nested-element
#------------------------------------------------------------------------
METHOD attribute on FORM can only have value POST or GET
####
<HTML>
<HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<FORM METHOD=wibble ACTION="http://www.cre.canon.co.uk/foo">
<SELECT NAME="foobar" SIZE="50,8">
<OPTION>foobar
</SELECT>
</FORM></BODY></HTML>
####
4:attribute-format
#------------------------------------------------------------------------
FORM element with SELECT element which has SIZE attribute
####
<HTML>
<HEAD><TITLE>title</TITLE></HEAD>
<BODY>
<FORM METHOD=post ACTION="http://www.cre.canon.co.uk/foo">
<SELECT NAME="foobar" SIZE="50,8">
<OPTION>foobar
</SELECT>
</FORM></BODY></HTML>
#------------------------------------------------------------------------
OPTION can have an optional closing tag
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD>
<BODY>
<FORM ACTION="foo.pl" METHOD=POST>
<SELECT NAME=COLOR>
<OPTION VALUE=red>Red
<OPTION VALUE=green>Green</OPTION>
<OPTION VALUE=blue>Blue</OPTION>
</SELECT>
</FORM>
</BODY></HTML>
#------------------------------------------------------------------------
Should now get a warning if you have an empty OPTION in a SELECT
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD>
<BODY>
<FORM ACTION="foo.pl" METHOD=POST>
<SELECT NAME=COLOR>
<OPTION VALUE=red>
<OPTION VALUE=green>Green</OPTION>
<OPTION VALUE=blue>Blue</OPTION>
</SELECT>
</FORM>
</BODY></HTML>
####
5:empty-container
#------------------------------------------------------------------------
FORM with all valid attributes
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD>
<BODY>
    <FORM
	ACTION="foo.pl" METHOD=POST
	enctype="application/x-www-form-urlencoded"
	onsubmit="submit()"
	onreset="reset()"
	target="_top"
	accept-charset="ISO-8859-1"
	id=foobar class=form style="foo" title="lock stock"
	lang=en dir=ltr
	onclick="click()"
	ondblclick="dblclick()"
	onmousedown="mousedown()"
	onmouseup="mouseup()"
	onmouseover="mouseover()"
	onmousemove="mousemove()"
	onmouseout="mouseout()"
	onkeypress="keypress()"
	onkeydown="keydown()"
	onkeyup="keyup()"
	>
		<input type=submit value=" submit ">
    </FORM>
</BODY></HTML>
#------------------------------------------------------------------------
LABEL with all valid attributes
####
<HTML><HEAD><TITLE>foo</TITLE></HEAD>
<BODY>
    <FORM ACTION="foo.pl" METHOD=POST>
	<label
	    FOR=textbox accesskey=a onfocus="focus()" onblur="blur()"
	    id=foobar class=formatting style="foo" title="lock stock"
	    lang=en dir=ltr
	    onclick="click()"
	    ondblclick="dblclick()"
	    onmousedown="mousedown()"
	    onmouseup="mouseup()"
	    onmouseover="mouseover()"
	    onmousemove="mousemove()"
	    onmouseout="mouseout()"
	    onkeypress="keypress()"
	    onkeydown="keydown()"
	    onkeyup="keyup()"
	    >
	    label text</label>
	<input type=text name=comment id=textbox>
    </FORM>
</BODY></HTML>
#------------------------------------------------------------------------
INPUT with all legal attributes
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>
    <FORM ACTION="foo.pl" METHOD=POST>
	<input type=text name=comment value="default"
		size=64 maxlength=64 tabindex=1 accesskey=f
		onfocus="focus()"
		onblur="blur()"
		onselect="select()"
		onchange="change()"
		align=center
		id=foobar class=form style="foo" title="lock stock"
		lang=en dir=ltr
		onclick="click()"
		ondblclick="dblclick()"
		onmousedown="mousedown()"
		onmouseup="mouseup()"
		onmouseover="mouseover()"
		onmousemove="mousemove()"
		onmouseout="mouseout()"
		onkeypress="keypress()"
		onkeydown="keydown()"
		onkeyup="keyup()"
	>
    </FORM>
</BODY></HTML>
#------------------------------------------------------------------------
simple FORM example (from the spec)
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>
 <FORM action="http://somesite.com/prog/adduser" method="post">
    <P>
    <LABEL for="firstname">First name: </LABEL>
              <INPUT type="text" id="firstname"><BR>
    <LABEL for="lastname">Last name: </LABEL>
              <INPUT type="text" id="lastname"><BR>
    <LABEL for="email">email: </LABEL>
              <INPUT type="text" id="email"><BR>
    <INPUT type="radio" name="sex" value="Male"> Male<BR>
    <INPUT type="radio" name="sex" value="Female"> Female<BR>
    <INPUT type="submit" value="Send"> <INPUT type="reset">
    </P>
 </FORM>
</BODY></HTML>
#------------------------------------------------------------------------
submitting a form to an email address
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>
 <FORM action="mailto:Kligor.T@gee.whiz.com" method="post">
 ...form contents...
 </FORM>
</BODY></HTML>
#------------------------------------------------------------------------
example form with INPUT controls
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>
 <FORM action="http://somesite.com/prog/adduser" method="post">
    <P>
    First name: <INPUT type="text" name="firstname"><BR>
    Last name: <INPUT type="text" name="lastname"><BR>
    email: <INPUT type="text" name="email"><BR>
    <INPUT type="radio" name="sex" value="Male"> Male<BR>
    <INPUT type="radio" name="sex" value="Female"> Female<BR>
    <INPUT type="submit" value="Send"> <INPUT type="reset">
    </P>
 </FORM>
</BODY></HTML>
#------------------------------------------------------------------------
javascript on input element
####
<HTML>
<HEAD>
<title>js example</title>
<META http-equiv="Content-Script-Type" content="text/javascript">
</HEAD>
<BODY>
 <FORM action="..." method="post">
    <P>
    <INPUT type="button" value="Click Me" onclick="verify()">
 </FORM>
</BODY>
</HTML>
#------------------------------------------------------------------------
form upload example
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>
<FORM action="http://server.dom/cgi/handle"
    enctype="multipart/form-data"
    method="post">
 <P>
 What is your name? <INPUT type="text" name="name_of_sender">
 What files are you sending? <INPUT type="file" name="name_of_files">
 </P>
</FORM>
</BODY></HTML>
#------------------------------------------------------------------------
example use of BUTTON element
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>
 <FORM action="http://somesite.com/prog/adduser" method="post">
    <P>
    First name: <INPUT type="text" name="firstname"><BR>
    Last name: <INPUT type="text" name="lastname"><BR>
    email: <INPUT type="text" name="email"><BR>
    <INPUT type="radio" name="sex" value="Male"> Male<BR>
    <INPUT type="radio" name="sex" value="Female"> Female<BR>
    <BUTTON name="submit" value="submit" type="submit">
    Send<IMG src="/icons/wow.gif" alt="wow"></BUTTON>
    <BUTTON name="reset" type="reset">
    Reset<IMG src="/icons/oops.gif" alt="oops"></BUTTON>
    </P>
 </FORM>
</BODY></HTML>
#------------------------------------------------------------------------
illegal example: can't set USEMAP on an IMG inside a BUTTON element
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>

<FORM method=POST action="/cgi-bin/foobar">
<BUTTON>
<IMG src="foo.gif" alt="alt text" usemap>
</BUTTON>
</FORM>

</BODY></HTML>
####
6:button-usemap
#------------------------------------------------------------------------
example SELECT and OPTION usage
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>
<FORM action="http://somesite.com/prog/component-select" method="post">
   <P>
   <SELECT multiple size="4" name="component-select">
      <OPTION selected value="Component_1_a">Component_1</OPTION>
      <OPTION selected value="Component_1_b">Component_2</OPTION>
      <OPTION>Component_3</OPTION>
      <OPTION>Component_4</OPTION>
      <OPTION>Component_5</OPTION>
      <OPTION>Component_6</OPTION>
      <OPTION>Component_7</OPTION>
   </SELECT>
   <INPUT type="submit" value="Send"><INPUT type="reset">
   </P>
</FORM>
</BODY></HTML>
#------------------------------------------------------------------------
example of OPTGROUP usage
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>
<FORM action="http://somesite.com/prog/someprog" method="post">
 <P>
 <SELECT name="ComOS">
     <OPTGROUP label="PortMaster 3">
       <OPTION label="3.7.1" value="pm3_3.7.1">PortMaster 3 with ComOS 3.7.1
       <OPTION label="3.7" value="pm3_3.7">PortMaster 3 with ComOS 3.7
       <OPTION label="3.5" value="pm3_3.5">PortMaster 3 with ComOS 3.5
     </OPTGROUP>
     <OPTGROUP label="PortMaster 2">
       <OPTION label="3.7" value="pm2_3.7">PortMaster 2 with ComOS 3.7
       <OPTION label="3.5" value="pm2_3.5">PortMaster 2 with ComOS 3.5
     </OPTGROUP>
     <OPTGROUP label="IRX">
       <OPTION label="3.7R" value="IRX_3.7R">IRX with ComOS 3.7R
       <OPTION label="3.5R" value="IRX_3.5R">IRX with ComOS 3.5R
     </OPTGROUP>
 </SELECT>
</FORM>
</BODY></HTML>
#------------------------------------------------------------------------
example TEXTAREA usage
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>
<FORM action="http://somesite.com/prog/text-read" method="post">
   <P>
   <TEXTAREA name="thetext" rows="20" cols="80">
   First line of initial text.
   Second line of initial text.
   </TEXTAREA>
   <INPUT type="submit" value="Send"><INPUT type="reset">
   </P>
</FORM>
</BODY></HTML>
#------------------------------------------------------------------------
LABEL example
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>
<FORM action="..." method="post">
<TABLE>
  <TR>
    <TD><LABEL for="fname">First Name</LABEL>
    <TD><INPUT type="text" name="firstname" id="fname">
  <TR>
    <TD><LABEL for="lname">Last Name</LABEL>
    <TD><INPUT type="text" name="lastname" id="lname">
</TABLE>
</FORM>
</BODY></HTML>
#------------------------------------------------------------------------
another, longer, LABEL example
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>
 <FORM action="http://somesite.com/prog/adduser" method="post">
    <P>
    <LABEL for="firstname">First name: </LABEL>
              <INPUT type="text" id="firstname"><BR>
    <LABEL for="lastname">Last name: </LABEL>
              <INPUT type="text" id="lastname"><BR>
    <LABEL for="email">email: </LABEL>
              <INPUT type="text" id="email"><BR>
    <INPUT type="radio" name="sex" value="Male"> Male<BR>
    <INPUT type="radio" name="sex" value="Female"> Female<BR>
    <INPUT type="submit" value="Send"> <INPUT type="reset">
    </P>
 </FORM>
</BODY></HTML>
#------------------------------------------------------------------------
implicitly associate two labels with two text input controls
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>
<FORM action="..." method="post">
<P>
<LABEL>
   First Name
   <INPUT type="text" name="firstname">
</LABEL>
<LABEL>
   <INPUT type="text" name="lastname">
   Last Name
</LABEL>
</P>
</FORM>
</BODY></HTML>
#------------------------------------------------------------------------
LEGEND example
####
<HTML><HEAD><TITLE>form: input example</TITLE></HEAD>
<BODY>
<FORM action="..." method="post">
 <P>
 <FIELDSET>
  <LEGEND>Personal Information</LEGEND>
  Last Name: <INPUT name="personal_lastname" type="text" tabindex="1">
  First Name: <INPUT name="personal_firstname" type="text" tabindex="2">
  Address: <INPUT name="personal_address" type="text" tabindex="3">
  ...more personal information...
 </FIELDSET>
 <FIELDSET>
  <LEGEND>Medical History</LEGEND>
  <INPUT name="history_illness"
         type="checkbox"
         value="Smallpox" tabindex="20"> Smallpox
  <INPUT name="history_illness"
         type="checkbox"
         value="Mumps" tabindex="21"> Mumps
  <INPUT name="history_illness"
         type="checkbox"
         value="Dizziness" tabindex="22"> Dizziness
  <INPUT name="history_illness"
         type="checkbox"
         value="Sneezing" tabindex="23"> Sneezing
  ...more medical history...
 </FIELDSET>
 <FIELDSET>
  <LEGEND>Current Medication</LEGEND>
  Are you currently taking any medication?
  <INPUT name="medication_now"
         type="radio"
         value="Yes" tabindex="35">Yes
  <INPUT name="medication_now"
         type="radio"
         value="No" tabindex="35">No

  If you are currently taking medication, please indicate
  it in the space below:
  <TEXTAREA name="current_medication"
            rows="20" cols="50"
            tabindex="40">
  </TEXTAREA>
 </FIELDSET>
</FORM>
</BODY></HTML>
#------------------------------------------------------------------------
TABINDEX example
####
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN"
   "http://www.w3.org/TR/REC-html40/strict.dtd">
<HTML>
<HEAD>
<TITLE>A document with FORM</TITLE>
</HEAD>
<BODY>
...some text...
<P>Go to the
<A tabindex="10" href="http://www.w3.org/">W3C Web site.</A>
...some more...
<BUTTON type="button" name="get-database"
           tabindex="1" onclick="get-database">
Get the current database.
</BUTTON>
...some more...
<FORM action="..." method="post">
<P>
<INPUT tabindex="1" type="text" name="field1">
<INPUT tabindex="2" type="text" name="field2">
<INPUT tabindex="3" type="submit" name="submit">
</P>
</FORM>
</BODY>
</HTML>
#------------------------------------------------------------------------
ACCESSKEY attribute example
####
<HTML>
<HEAD>
<TITLE>A document with FORM</TITLE>
</HEAD>
<BODY>
<FORM action="..." method="post">
<P>
<LABEL for="fuser" accesskey="U">
User Name
</LABEL>
<INPUT type="text" name="user" id="fuser">
</P>
</FORM>
</BODY>
</HTML>
#------------------------------------------------------------------------
