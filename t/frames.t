#!/usr/local/bin/perl -w
#
# frames.t - basic weblint tests for frames
#
# Copyright (C) 1995-1999 Neil Bowers.  All rights reserved.
#
# See README for additional blurb.
# Bugs, comments, suggestions welcome: neilb@weblint.org
#
# $Id: frames.t,v 1.2 1999/04/06 21:17:24 neilb Exp $
#

use lib '/home/neilb/weblint/lib';
use Weblint::Test qw(run_tests);
use strict;

run_tests();

exit 0;

#============================================================================
#============================================================================

__END__
NOFRAMES must appear in a FRAMESET
####
<HTML>
<HEAD><TITLE>simple frame document</TITLE></HEAD>

<BODY>

    <NOFRAMES>
	Hello, World!
    </NOFRAMES>

</BODY>

</HTML>
####
6:required-context
#------------------------------------------------------------------------
simple frame document (taken from HTML 4.0 spec)
####
<HTML>
<HEAD><TITLE>simple frame document</TITLE></HEAD>

<FRAMESET COLS="20%, 80%">

    <FRAMESET rows="100, 200">
	<FRAME src="contents1.html">
	<FRAME src="contents1.gif">
    </FRAMESET>
    <FRAME src="contents3.html">

</FRAMESET>

</HTML>
####
15:implied-element
#------------------------------------------------------------------------
simple frame document (taken from HTML 4.0 spec)
####
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN"
   "http://www.w3.org/TR/REC-html40/frameset.dtd">
<HTML>
<HEAD>
<TITLE>A simple frameset document</TITLE>
</HEAD>
<FRAMESET cols="20%, 80%">
  <FRAMESET rows="100, 200">
      <FRAME src="contents_of_frame1.html">
      <FRAME src="contents_of_frame2.gif">
  </FRAMESET>
  <FRAME src="contents_of_frame3.html">
  <NOFRAMES>
      <P>This frameset document contains:
      <UL>
         <LI><A href="contents_of_frame1.html">Some neat contents</A>
         <LI><IMG src="contents_of_frame2.gif" alt="A neat image">
         <LI><A href="contents_of_frame3.html">Some other neat contents</A>
      </UL>
  </NOFRAMES>
</FRAMESET>
</HTML>
#------------------------------------------------------------------------
sharing data among frames (taken from HTML 4.0 spec)
####
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN"
   "http://www.w3.org/TR/REC-html40/frameset.dtd">
<HTML>
<HEAD>
<TITLE>This is a frameset with OBJECT in the HEAD</TITLE>
<!-- This OBJECT is not rendered! -->
<OBJECT id="myobject" data="data.bar"></OBJECT>
</HEAD>
<FRAMESET>
    <FRAME src="bianca.html" name="bianca">
</FRAMESET>
</HTML>
####
13:implied-element
#------------------------------------------------------------------------
bianca.html from the previous example
####
<!-- In bianca.html -->
<HTML>
<HEAD>
<TITLE>Bianca's page</TITLE>
</HEAD>
<BODY>
...the beginning of the document...
<P>
<SCRIPT type="text/javascript">
parent.myobject.myproperty
</SCRIPT>
...the rest of the document...
</BODY>
</HTML>
#------------------------------------------------------------------------
FRAMESET example (taken from html 4.0 spec)
####
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN"
   "http://www.w3.org/TR/REC-html40/frameset.dtd">
<HTML>
<HEAD>
<TITLE>A frameset document</TITLE>
</HEAD>
<FRAMESET cols="33%,33%,33%">
  <FRAMESET rows="*,200">
      <FRAME src="contents_of_frame1.html">
      <FRAME src="contents_of_frame2.gif">
  </FRAMESET>
  <FRAME src="contents_of_frame3.html">
  <FRAME src="contents_of_frame4.html">
</FRAMESET>
</HTML>
####
16:implied-element
#------------------------------------------------------------------------
legal example showing use of decorative border attributes
####
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN"
   "http://www.w3.org/TR/REC-html40/frameset.dtd">
<HTML>
<HEAD>
<TITLE>A frameset document</TITLE>
</HEAD>
<FRAMESET cols="33%,33%,33%">
  <FRAMESET rows="*,200">
      <FRAME src="contents_of_frame1.html" scrolling="no">
      <FRAME src="contents_of_frame2.gif"
                marginwidth="10" marginheight="15"
                noresize>
  </FRAMESET>
  <FRAME src="contents_of_frame3.html" frameborder="0">
  <FRAME src="contents_of_frame4.html" frameborder="0">
</FRAMESET>
</HTML>
####
18:implied-element
#------------------------------------------------------------------------
another example from the spec
####
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN"
   "http://www.w3.org/TR/REC-html40/frameset.dtd">
<HTML>
<HEAD>
<TITLE>A frameset document</TITLE>
</HEAD>
<FRAMESET rows="50%,50%">
   <FRAME name="fixed" src="init_fixed.html">
   <FRAME name="dynamic" src="init_dynamic.html">
</FRAMESET>
</HTML>
####
12:implied-element
#------------------------------------------------------------------------
target attribute to redirect a link to a specific frame
####
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
   "http://www.w3.org/TR/REC-html40/loose.dtd">
<HTML>
<HEAD>
<TITLE>A document with anchors with specific targets</TITLE>
</HEAD>
<BODY>
...beginning of the document...
<P>Now you may advance to
    <A href="slide2.html" target="dynamic">slide 2.</A>
...more document...
<P>You're doing great. Now on to
    <A href="slide3.html" target="dynamic">slide 3.</A>
</BODY>
</HTML>
#------------------------------------------------------------------------
Setting the default target for links
####
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"
   "http://www.w3.org/TR/REC-html40/loose.dtd">
<HTML>
<HEAD>
<TITLE>A document with BASE with a specific target</TITLE>
<BASE href="http://www.mycom.com/Slides" target="dynamic">
</HEAD>
<BODY>
...beginning of the document...
<P>Now you may advance to <A href="slide2.html">slide 2.</A>
...more document...
<P>You're doing great. Now on to
       <A href="slide3.html">slide 3.</A>
</BODY>
</HTML>
#------------------------------------------------------------------------
NOFRAMES example from the spec
####
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN"
     "http://www.w3.org/TR/REC-html40">
  <HTML>
  <HEAD>
  <TITLE>A frameset document with NOFRAMES</TITLE>
  </HEAD>
  <FRAMESET cols="50%, 50%">
     <FRAME src="main.html">
     <FRAME src="table_of_contents.html">
     <NOFRAMES>
     <P>Here is the <A href="main-noframes.html">
              non-frame based version of the document.</A>
     </NOFRAMES>
  </FRAMESET>
  </HTML>
#------------------------------------------------------------------------
Long descriptions of frames
####
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN"
   "http://www.w3.org/TR/REC-html40">
<HTML>
<HEAD>
<TITLE>A poorly-designed frameset document</TITLE>
</HEAD>
<FRAMESET cols="20%, 80%">
   <FRAME src="table_of_contents.html">
   <FRAME src="ostrich.gif" longdesc="ostrich-desc.html">
</FRAMESET>
</HTML>
####
12:implied-element
#------------------------------------------------------------------------
don't include images in frames - use HTML which contains the image
####
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN"
   "http://www.w3.org/TR/REC-html40">
<HTML>
<HEAD>
<TITLE>A well-designed frameset document</TITLE>
</HEAD>
<FRAMESET cols="20%, 80%">
   <FRAME src="table_of_contents.html">
   <FRAME src="ostrich-container.html">
</FRAMESET>
</HTML>
####
12:implied-element
#------------------------------------------------------------------------
here's the image from the previous example
####
<!-- In ostrich-container.html: -->
<HTML>
<HEAD>
<TITLE>The fast and powerful ostrich</TITLE>
</HEAD>
<P>
<OBJECT data="ostrich.gif" type="image/gif">
These ostriches sure taste good!
</OBJECT>
</HTML>
#------------------------------------------------------------------------
IFRAME example from the spec
####
<HTML>
<HEAD>
<TITLE>IFRAME example</TITLE>
</HEAD>
  <IFRAME src="foo.html" width="400" height="500"
             scrolling="auto" frameborder="1">
  [Your user agent does not support frames or is currently configured
  not to display frames. However, you may visit
  <A href="foo.html">the related document.</A>]
  </IFRAME>
</HTML>
#------------------------------------------------------------------------
