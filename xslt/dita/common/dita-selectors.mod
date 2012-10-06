<!--
This program is free software; you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
details.

You should have received a copy of the GNU Lesser General Public License
along with this program; see the file COPYING.LGPL.  If not, write to the
Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.
-->

<!--
This file contains a set of selectors for DITA content. The selectors reflect
the level of granularity that is implemented by the yelp-xsl stylesheets, and
may not be suitable for other uses. The selectors match on element names as
well as class attributes, so they will work with or without DTDs (although
specializations not covered here of course require DTDs). The selectors are
all of the form *[predicate]. This allows axes to be prepended and predicates
to be appended. They are always named according to the domain of their most
base element and the local name of their most specialized element. They are
grouped according to their most base element.
-->

<!-- ===========================================================================
topic/body
-->
<!ENTITY topic_body "*[
  name(.) = 'body' or name(.) = 'conbody' or name(.) = 'taskbody' or
  starts-with(@class, '- topic/body ')
  ]">
<!ENTITY topic_body_all "*[
  name(.) = 'body' or name(.) = 'conbody' or name(.) = 'taskbody' or
  starts-with(@class, '- topic/body ')
  ]">

<!-- ===========================================================================
topic/desc
-->
<!ENTITY topic_desc "*[name(.) = 'desc' or starts-with(@class, '- topic/desc ')]">

<!-- ===========================================================================
topic/fig
-->
<!ENTITY topic_fig "*[name(.) = 'fig' or starts-with(@class, '- topic/fig ')]">

<!-- ===========================================================================
topic/image
-->
<!ENTITY topic_image "*[name(.) = 'image' or starts-with(@class, '- topic/image ')]">

<!-- ===========================================================================
topic/itemgroup
-->
<!ENTITY topic_info "*[
  name(.) = 'info' or starts-with(@class, '- topic/itemgroup task/info ')]">
<!ENTITY topic_stepresult "*[
  name(.) = 'stepresult' or starts-with(@class, '- topic/itemgroup task/stepresult ')]">
<!ENTITY topic_stepxmp "*[
  name(.) = 'stepxmp' or starts-with(@class, '- topic/itemgroup task/stepxmp ')]">
<!ENTITY topic_tutorialinfo "*[
  name(.) = 'tutorialinfo' or starts-with(@class, '- topic/itemgroup task/tutorialinfo ')]">

<!-- ===========================================================================
topic/keyword
-->
<!ENTITY topic_cmdname "*[
  name(.) = 'cmdname' or starts-with(@class, '- topic/keyword sw-d/cmdname ')]">
<!ENTITY topic_varname "*[
  name(.) = 'varname' or starts-with(@class, '- topic/keyword sw-d/varname ')]">
<!ENTITY topic_wintitle "*[
  name(.) = 'wintitle' or starts-with(@class, '- topic/keyword sw-d/wintitle ')]">

<!-- ===========================================================================
topic/li
-->
<!ENTITY topic_step "*[
  name(.) = 'step' or starts-with(@class, '- topic/li task/step ')]">
<!ENTITY topic_stepsection "*[
  name(.) = 'stepsection' or starts-with(@class, '- topic/li task/stepsection ')]">
<!ENTITY topic_substep "*[
  name(.) = 'substep' or starts-with(@class, '- topic/li task/substep ')]">
<!ENTITY topic_li "*[
name(.) = 'li' or (
  starts-with(@class, '- topic/li ')
  and not(starts-with(@class, '- topic/li task/step '))
  and not(starts-with(@class, '- topic/li task/stepsection '))
  and not(starts-with(@class, '- topic/li task/substep '))
  )]">
<!ENTITY topic_li_all "*[
  name(.) = 'li' or name(.) = 'step' or name(.) = 'stepsection' or name(.) = 'substep' or
  starts-with(@class, '- topic/li ')
  ]">

<!-- ===========================================================================
topic/link
-->
<!ENTITY topic_link "*[name(.) = 'link' or starts-with(@class, '- topic/link ')]">

<!-- ===========================================================================
topic/linkinfo
-->
<!ENTITY topic_linkinfo "*[name(.) = 'linkinfo' or starts-with(@class, '- topic/linkinfo ')]">

<!-- ===========================================================================
topic/linklist
-->
<!ENTITY topic_linklist "*[name(.) = 'linklist' or starts-with(@class, '- topic/linklist ')]">

<!-- ===========================================================================
topic/linkpool
-->
<!ENTITY topic_linkpool "*[name(.) = 'linkpool' or starts-with(@class, '- topic/linkpool ')]">

<!-- ===========================================================================
topic/linktext
-->
<!ENTITY topic_linktext "*[name(.) = 'linktext' or starts-with(@class, '- topic/linktext ')]">

<!-- ===========================================================================
topic/note
-->
<!ENTITY topic_note "*[name(.) = 'note' or starts-with(@class, '- topic/note ')]">

<!-- ===========================================================================
topic/object
-->
<!ENTITY topic_object "*[name(.) = 'object' or starts-with(@class, '- topic/object ')]">

<!-- ===========================================================================
topic/ol
-->
<!ENTITY topic_steps "*[
  name(.) = 'steps' or starts-with(@class, '- topic/ol task/steps ')]">
<!ENTITY topic_steps-unordered "*[
  name(.) = 'steps-unordered' or starts-with(@class, '- topic/ol task/steps-unordered ')]">
<!ENTITY topic_substeps "*[
  name(.) = 'substeps' or starts-with(@class, '- topic/ol task/substeps ')]">
<!ENTITY topic_ol "*[
  name(.) = 'ol' or (
  starts-with(@class, '- topic/ol ')
  and not(starts-with(@class, '- topic/ol task/steps '))
  and not(starts-with(@class, '- topic/ol task/steps-unordered '))
  and not(starts-with(@class, '- topic/ol task/substeps '))
)]">
<!ENTITY topic_ol_all "*[
  name(.) = 'ol' or name(.) = 'steps' or name(.) = 'steps-unordered' or name(.) = 'substeps' or
  starts-with(@class, '- topic/ol ')
  ]">

<!-- ===========================================================================
topic/p
-->
<!ENTITY topic_p "*[name(.) = 'p' or starts-with(@class, '- topic/p ')]">

<!-- ===========================================================================
topic/ph
-->
<!ENTITY topic_b "*[
  name(.) = 'b' or starts-with(@class, '- topic/ph hi-d/b ')]">
<!ENTITY topic_cmd "*[
  name(.) = 'cmd' or starts-with(@class, '- topic/ph task/cmd ')]">
<!ENTITY topic_codeph "*[
  name(.) = 'codeph' or starts-with(@class, '- topic/ph pr-d/codeph ')]">
<!ENTITY topic_filepath "*[
  name(.) = 'filepath' or starts-with(@class, '- topic/ph sw-d/filepath ')]">
<!ENTITY topic_i "*[
  name(.) = 'i' or starts-with(@class, '- topic/ph hi-d/i ')]">
<!ENTITY topic_menucascade "*[
  name(.) = 'menucascade' or starts-with(@class, '- topic/ph hi-d/menucascade ')]">
<!ENTITY topic_systemoutput "*[
  name(.) = 'systemoutput' or starts-with(@class, '- topic/ph sw-d/systemoutput ')]">
<!ENTITY topic_tt "*[
  name(.) = 'tt' or starts-with(@class, '- topic/ph hi-d/tt ')]">
<!ENTITY topic_u "*[
  name(.) = 'u' or starts-with(@class, '- topic/ph hi-d/u ')]">
<!ENTITY topic_uicontrol "*[
  name(.) = 'uicontrol' or starts-with(@class, '- topic/ph ui-d/uicontrol ')]">
<!ENTITY topic_userinput "*[
  name(.) = 'userinput' or starts-with(@class, '- topic/ph sw-d/userinput ')]">

<!-- ===========================================================================
topic/pre
-->
<!ENTITY topic_codeblock "*[
  name(.) = 'codeblock' or starts-with(@class, '- topic/pre pr-d/codeblock ')]">
<!ENTITY topic_pre "*[
  name(.) = 'pre' or (
  starts-with(@class, '- topic/pre ')
  and not(starts-with(@class, '- topic/pre pr-d/codeblock '))
  )]">
<!ENTITY topic_pre_all "*[
  name(.) = 'pre' or name(.) = 'codeblock' or
  starts-with(@class, '- topic/pre ')
  ]">

<!-- ===========================================================================
topic/prolog
-->
<!ENTITY topic_prolog "*[name(.) = 'prolog' or starts-with(@class, '- topic/prolog ')]">

<!-- ===========================================================================
topic/related-links
-->
<!ENTITY topic_related-links "*[name(.) = 'related-links' or starts-with(@class, '- topic/related-links ')]">

<!-- ===========================================================================
topic/section
-->
<!ENTITY topic_context "*[
  name(.) = 'context' or starts-with(@class, '- topic/section task/context ')]">
<!ENTITY topic_postreq "*[
  name(.) = 'postreq' or starts-with(@class, '- topic/section task/postreq ')]">
<!ENTITY topic_prereq  "*[
  name(.) = 'prereq'  or starts-with(@class, '- topic/section task/prereq ')]">
<!ENTITY topic_result  "*[
  name(.) = 'result'  or starts-with(@class, '- topic/section task/result ')]">
<!ENTITY topic_steps-informal "*[
  name(.) = 'steps-informal'  or starts-with(@class, '- topic/section task/steps-informal ')]">
<!ENTITY topic_section "*[
  name(.) = 'section'  or (
  starts-with(@class, '- topic/section ')
  and not(starts-with(@class, '- topic/section task/context '))
  and not(starts-with(@class, '- topic/section task/postreq '))
  and not(starts-with(@class, '- topic/section task/prereq '))
  and not(starts-with(@class, '- topic/section task/result '))
  and not(starts-with(@class, '- topic/section task/steps-informal '))
  )]">
<!ENTITY topic_section_all "*[
  name(.) = 'section' or name(.) = 'context' or name(.) = 'prereq' or
  name(.) = 'postreq' or name(.) = 'result'  or name(.) = 'steps-informal' or
  starts-with(@class, '- topic/section ')
  ]">

<!-- ===========================================================================
topic/shortdesc
-->
<!ENTITY topic_shortdesc "*[name(.) = 'shortdesc' or starts-with(@class, '- topic/shortdesc ')]">

<!-- ===========================================================================
topic/simpletable
-->
<!ENTITY topic_simpletable "*[name(.) = 'simpletable' or starts-with(@class, '- topic/simpletable ')]">

<!-- ===========================================================================
topic/stentry
-->
<!ENTITY topic_stentry "*[name(.) = 'stentry' or starts-with(@class, '- topic/stentry ')]">

<!-- ===========================================================================
topic/sthead
-->
<!ENTITY topic_sthead "*[name(.) = 'sthead' or starts-with(@class, '- topic/sthead ')]">

<!-- ===========================================================================
topic/strow
-->
<!ENTITY topic_strow "*[name(.) = 'strow' or starts-with(@class, '- topic/strow ')]">

<!-- ===========================================================================
topic/text
-->
<!ENTITY topic_text "*[name(.) = 'text' or starts-with(@class, '- topic/text ')]">

<!-- ===========================================================================
topic/title
-->
<!ENTITY topic_title "*[name(.) = 'title' or starts-with(@class, '- topic/title ')]">

<!-- ===========================================================================
topic/topic
-->
<!ENTITY topic_topic "*[
  name(.) = 'topic' or name(.) = 'concept' or name(.) = 'task' or
  starts-with(@class, '- topic/topic ')
  ]">
<!ENTITY topic_topic_all "*[
  name(.) = 'topic' or name(.) = 'concept' or name(.) = 'task' or
  starts-with(@class, '- topic/topic ')
  ]">

<!-- ===========================================================================
topic/ul
-->
<!ENTITY topic_ul "*[name(.) = 'ul' or starts-with(@class, '- topic/ul ')]">
