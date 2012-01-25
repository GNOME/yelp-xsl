#!/bin/awk
# -*- indent-tabs-mode: nil -*-
# xsldoc.awk - Convert inline documentation to XML suitable for xsldoc.xsl
# Copyright (C) 2006 Shaun McCance <shaunm@gnome.org>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

# This program is free software, but that doesn't mean you should use it.
# It's a hackish bit of awk and XSLT to do inline XSLT documentation with
# a simple syntax in comments.  I had originally tried to make a public
# inline documentation system for XSLT using embedded XML, but it just got
# very cumbersome.  XSLT should have been designed from the ground up with
# an inline documentation format.
#
# None of the existing inline documentation tools (gtk-doc, doxygen, etc.)
# really work well for XSLT, so I rolled my own simple comment-based tool.
# This tool is sufficient for producing the documentation I need, but I
# just don't have the time or inclination to make a robust system suitable
# for public use.
#
# You are, of course, free to use any of this.  If you do proliferate this
# hack, it is requested (though not required, that would be non-free) that
# you atone for your actions.  A good atonement would be contributing to
# free software.


# This function takes a line of input and converts inline syntax into real
# XML.  Inline syntax marks up special things like ${this}, with a leading
# special character and the marked-up content in curly braces.  Here's the
# list of special characters and their meanings:
#
# !{}  the id of a stylesheet file, i.e. the file name without the .xsl
# *{}  the name of a named XSLT template
# %{}  the name of a defined XSLT mode
# @{}  the name of a parameter to the stylesheet
# ${}  the name of a parameter to the current template
#
# There is currently no way of escaping these sequences, but note that the
# special characters on their own do nothing.  They are only matched when
# directly preceding an opening curly brace, and when there's a matching
# closing curly brace somewhere.  The syntax is hackish.  Thus, it is not
# intended for public consumption outside gnome-doc-utils
#
# Note that we need to add a special character for processing instructions.
function runline (line, ix, jx, pre, aft, char, name, id, fmt) {
    ix = match(line, /[\*\$\@\+\%\!\#]\{[^\}]*\}/)
    if (ix > 0) {
        jx = ix + index(substr(line, ix), "}");
	pre = substr(line, 1, ix - 1);
	aft = substr(line, jx);
	char = substr(line, ix, 1);
	name = substr(line, ix + 2, jx - ix - 3);
	id = name;
	if (char == "!")
	    fmt = "<file xref='%s'>%s</file>";
	else if (char == "*")
	    fmt = "<code style='xslt-template' xref='%s'>%s</code>";
	else if (char == "%")
	    fmt = "<code style='xslt-mode' xref='%s'>%s</code>";
  else if (char == "+")
      fmt = "<code style='xslt-key' xref='%s'>%s</code>";
	else if (char == "@") 
	    fmt = "<code style='xslt-param' xref='P.%s'>%s</code>";
	else if (char == "$") 
	    fmt = "<code style='xslt-param'>"name"</code>";
	else if (char == "#")
	    fmt = "<code>"name"</code>";
	else
	    fmt = name;
	return sprintf("%s%s%s",
		       runline(pre),
		       sprintf(fmt, id, name),
		       runline(aft) );
    } else {
	return line;
    }
}

BEGIN {
print "<page xmlns='http://projectmallard.org/1.0/'>"

# What mode we're using to process the line:
#   "" - outside of a doc comment
#   title - doc comment just started, expecting title
#   desc - title was processed, optional desc may come next
#   meta - looking for meta directives starting with :
#   params - looking for param definitions starting with $
#   body - reading normal text content
cur_line_mode = "";

# The type of doc comment we're processing:
#   stylesheet, template, mode, param
comment_type = "";

# Whether the current line mode just ended
end_mode = 0;

# Whether the current doc comment just ended
end_comment = 0;

# The type of the block we're in, or "" if we're not
cur_block = "";
}

# Things that start comment blocks
/<\!--\!\!/ {
    cur_line_mode = "title";
    comment_type = "stylesheet";
    cur_block = "";
    next;
}
/<\!--\*\*/ {
    print "\n<section style='xslt-template'>";
    cur_line_mode = "title";
    comment_type = "template";
    cur_block = "";
    next;
}
/<\!--\%\%/ {
    print "\n<section style='xslt-mode'>";
    cur_line_mode = "title";
    comment_type = "mode";
    cur_block = "";
    next;
}
/<\!--\+\+/ {
    print "\n<section style='xslt-key'>";
    cur_line_mode = "title";
    comment_type = "key";
    cur_block = "";
    next;
}
/<\!--\@\@/ {
    print "\n<section style='xslt-param'>"
    cur_line_mode = "title";
    comment_type = "param";
    cur_block = "";
    next;
}

# One-line comments to mark things private
/<\!--\#\!.*-->/ {
    split($0, a);
    printf "<?xslt-private %s?>\n", a[2];
    next;
}
/<\!--\#\*.*-->/ {
    split($0, a);
    printf "<?xslt-private %s?>\n", a[2];
    next;
}
/<\!--\#\%.*-->/ {
    split($0, a);
    printf "<?xslt-private %s?>\n", a[2];
    next;
}
/<\!--\#\@.*-->/ {
    split($0, a);
    printf "<?xslt-private %s?>\n", a[2];
    next;
}

# Not in a doc comment, and not a one-liner, so skip
comment_type == "" { next; }

# Reset and set end_mode and end_comment
// { end_mode = 0; end_comment = 0; }
/^$/ { end_mode = 1; }
/-->/ { end_mode = 1; end_comment = 1; }

### MODE: title
# First line of a doc comment is the title.  Store it and output it later,
# because it should come after the info element.
cur_line_mode == "title" {
    cur_title = runline($0);
    cur_line_mode = "desc";
    print "  <info>";
    printf "    <desc>";
    next;
}

### MODE: desc
# Closing off desc with meta lines
cur_line_mode == "desc" && /^:.+:.+$/ {
    cur_line_mode = "meta";
    print "</desc>";
}
# Closing off desc, directly to params
cur_line_mode == "desc" && /^\$.+:.+$/ {
    cur_line_mode = "params";
    print "</desc>";
    print "  </info>"
    printf "  <title>%s</title>\n", cur_title;
}
# Closing off desc, directly to body
cur_line_mode == "desc" && end_mode {
    cur_line_mode = "body";
    cur_block = "";
    print "</desc>";
    print "  </info>"
    printf "  <title>%s</title>\n", cur_title;
}
# Haven't closed off desc, so we output the line
cur_line_mode == "desc" {
    printf "%s", runline($0);
    next;
}

### MODE: meta
# Closing off meta, going to params
cur_line_mode == "meta" && /^\$.+:.+$/ {
    cur_line_mode = "params";
    print "  </info>"
    printf "  <title>%s</title>\n", cur_title;
}
# Outputting meta
cur_line_mode == "meta" && /^:Requires:.+$/ {
    val = $0;
    sub(/^\:/, "", val);
    sub(/^[^:]*:[ \t]*/, "", val);
    split(val, vals);
    for (valsi in vals) {
        printf "    <link type='xslt-requires' xref='%s'/>\n", vals[valsi];
    }
    next;
}
cur_line_mode == "meta" && /^:Stub:.*$/ {
    print "    <stub xmlns='http://projects.gnome.org/yelp/xsldoc/'/>\n";
    next;
}
cur_line_mode == "meta" && /^:Revision:.+$/ {
    val = $0;
    sub(/^\:/, "", val);
    sub(/^[^:]*:[ \t]*/, "", val);
    printf "    <revision %s/>\n", val;
    next;
}
# Unknown meta
cur_line_mode == "meta" && /^:.+:.+$/ {
    next;
}
# Closing off meta, directly to body
cur_line_mode == "meta" {
    cur_line_mode = "body";
    cur_block = "";
    print "  </info>"
    printf "  <title>%s</title>\n", cur_title;
}

### MODE: params
# Beginning of a new param, possibly close last param
cur_line_mode == "params" && /^\$.+:.+$/ {
    if (cur_block == "param") {
	print "</p>\n    </item>"
    }
    else {
	print "  <synopsis><title>Parameters</title><terms>"
    }
    cur_block = "param";
    key = $0;
    val = $0;
    sub(/^\$/, "", key);
    sub(/:.*$/, "", key);
    sub(/^[^:]*:[ \t]*/, "", val);
    print "    <item>"
    printf "      <title><code>%s</code></title>\n", runline(key);
    printf "      <p>%s", runline(val);
    next
}
# Ending params and going to body
cur_line_mode == "params" && end_mode {
    if (cur_block == "param") {
	print "</p>\n    </item>"
    }
    cur_line_mode = "body";
    cur_block = "";
    print "  </terms></synopsis>";
}
# Continuation of previous param
cur_line_mode == "params" {
    printf " %s", runline($0);
    next;
}

### MODE: body
function endblock () {
    if (cur_block == "p") {
	print "</p>";
    }
    else if (cur_block == "comment") {
	print "</p></comment>";
    }
    cur_block = "";
}
# Starting a remark
cur_line_mode == "body" && /^REMARK:/ {
    endblock();
    sub(/^REMARK:[ \t]*/, "", $0);
    printf "  <comment><p>%s", runline($0);
    cur_block = "comment";
    next;
}
cur_line_mode == "body" && !end_mode {
    if (cur_block == "") {
	printf "  <p>%s", runline($0);
	cur_block = "p";
    }
    else {
	printf " %s", runline($0);
    }
}
# Possibly ending a block
cur_line_mode == "body" && end_mode {
    endblock();
}
# EVERYTHING HERE

end_comment && comment_type == "template" { print "</section>"; }
end_comment && comment_type == "mode" { print "</section>"; }
end_comment && comment_type == "key" { print "</section>"; }
end_comment && comment_type == "param" { print "</section>"; }
end_comment {
    cur_line_mode = "";
    comment_type = "";
}

END { print "</page>" }

// { next; }

cur_line_mode == "top" {
  printf "  <desc>%s</desc>\n\n", runline($0);
}

cur_line_mode == "params" && /^\$.+:.+$/ {
  key = $0;
  val = $0;
  sub(/^\$/, "", key);
  sub(/:.*$/, "", key);
  sub(/^[^:]*:[ \t]*/, "", val);
  printf "    <param><name>%s</name>\n", key;
  printf "      <desc>%s</desc>\n", runline(val);
  print  "    </param>";
  next;
}
cur_line_mode == "params" && /^:.+:.+$/ {
  print "  </params>\n";
  print "  <metas>";
  cur_line_mode = "meta";
}
cur_line_mode == "params" && inend {
  print "  </params>\n";
  print "  <body>";
  body = 1;
  cur_line_mode = "body";
}

cur_line_mode == "meta" && /^:.+:.+$/ {
  key = $0;
  val = $0;
  sub(/^\:/, "", key);
  sub(/:.*$/, "", key);
  sub(/^\:/, "", val);
  sub(/^[^:]*:[ \t]*/, "", val);
  printf "    <meta><name>%s</name>\n", key;
  printf "      <desc>%s</desc>\n", runline(val);
  print  "    </meta>";
  next;
}
cur_line_mode == "meta" && inend {
  print "  </metas>";
  print "  </info>";
  body = 1;
  cur_line_mode = "body";
}

cur_line_mode == "body" && /^REMARK:/ {
  sub(/^REMARK:[ \t]*/, "", $0);
  printf "  <remark>%s", runline($0);
  cur_line_mode = "para";
  inpara = "remark";
  next;
}
cur_line_mode == "body" && !inend {
  printf "  <para>%s", runline($0);
  cur_line_mode = "para";
  next;
}
cur_line_mode == "para" && inend {
  if (inpara == "remark") {
    printf "</%s>\n", inpara;
  }
  else if (inpara) {
    printf "</para></%s>\n", inpara;
  } else {
    print "</para>";
  }
  cur_line_mode = "body";
  inpara = "";
}
cur_line_mode == "para" && !inend {
  printf "\n  %s", runline($0);
  next;
}

