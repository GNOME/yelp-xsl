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
along with this program; see the file COPYING.LGPL.  If not, see <http://www.gnu.org/licenses/>.
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
map/map
-->
<!ENTITY map_map "*[
  name(.) = 'map' or name(.) = 'bookmap' or
  contains(@class, ' map/map ')]">

<!-- ===========================================================================
map/topicmeta
-->
<!ENTITY map_topicmeta "*[name(.) = 'topicmeta' or contains(@class, ' map/topicmeta ')]">

<!-- ===========================================================================
map/topicref
-->
<!ENTITY map_topicref "*[
  name(.) = 'topicref' or name(.) = 'chapter' or name(.) = 'part' or
  contains(@class, ' map/topicref ')]">

<!-- ===========================================================================
topic/alt
-->
<!ENTITY topic_alt "*[name(.) = 'alt' or contains(@class, ' topic/alt ')]">

<!-- ===========================================================================
topic/author
-->
<!ENTITY topic_author "*[name(.) = 'author' or contains(@class, ' topic/author ')]">

<!-- ===========================================================================
topic/body
-->
<!ENTITY topic_body "*[
  name(.) = 'body' or name(.) = 'conbody' or name(.) = 'refbody' or
  name(.) = 'taskbody' or
  contains(@class, ' topic/body ')
  ]">
<!ENTITY topic_body_all "*[
  name(.) = 'body' or name(.) = 'conbody' or name(.) = 'refbody' or
  name(.) = 'taskbody' or
  contains(@class, ' topic/body ')
  ]">

<!-- ===========================================================================
topic/bodydiv
-->
<!ENTITY topic_bodydiv "*[
  name(.) = 'bodydiv' or name(.) = 'conbodydiv' or name(.) = 'refbodydiv' or
  contains(@class, ' topic/bodydiv ')
  ]">
<!ENTITY topic_bodydiv_all "*[
  name(.) = 'bodydiv' or name(.) = 'conbodydiv' or name(.) = 'refbodydiv' or
  contains(@class, ' topic/bodydiv ')
  ]">

<!-- ===========================================================================
topic/copyright
-->
<!ENTITY topic_copyright "*[name(.) = 'copyright' or contains(@class, ' topic/copyright ')]">

<!-- ===========================================================================
topic/copyrholder
-->
<!ENTITY topic_copyrholder "*[name(.) = 'copyrholder' or contains(@class, ' topic/copyrholder ')]">

<!-- ===========================================================================
topic/copyryear
-->
<!ENTITY topic_copyryear "*[name(.) = 'copyryear' or contains(@class, ' topic/copyryear ')]">

<!-- ===========================================================================
topic/desc
-->
<!ENTITY topic_desc "*[name(.) = 'desc' or contains(@class, ' topic/desc ')]">

<!-- ===========================================================================
topic/dd
-->
<!ENTITY topic_dd "*[
  name(.) = 'dd' or name(.) = 'pd' or
  contains(@class, ' topic/dd ')]">

<!-- ===========================================================================
topic/ddhd
-->
<!ENTITY topic_ddhd "*[name(.) = 'ddhd' or contains(@class, ' topic/ddhd ')]">

<!-- ===========================================================================
topic/dl
-->
<!ENTITY topic_dl "*[
  name(.) = 'dl' or name(.) = 'parml' or
  contains(@class, ' topic/dl ')]">

<!-- ===========================================================================
topic/dlentry
-->
<!ENTITY topic_dlentry "*[
  name(.) = 'dlentry' or name(.) = 'plentry' or
  contains(@class, ' topic/dlentry ')]">

<!-- ===========================================================================
topic/dlhead
-->
<!ENTITY topic_dlhead "*[name(.) = 'dlhead' or contains(@class, ' topic/dlhead ')]">

<!-- ===========================================================================
topic/dt
-->
<!ENTITY topic_dt "*[
  name(.) = 'dt' or name(.) = 'pt' or
  contains(@class, ' topic/dt ')]">

<!-- ===========================================================================
topic/dthd
-->
<!ENTITY topic_dthd "*[name(.) = 'dthd' or contains(@class, ' topic/dthd ')]">

<!-- ===========================================================================
topic/fig
-->
<!ENTITY topic_imagemap "*[
  name(.) = 'imagemap' or contains(@class, ' topic/fig ut-d/imagemap ')]">
<!ENTITY topic_fig "*[
  name(.) = 'fig' or (
  contains(@class, ' topic/fig ')
  and not(contains(@class, ' topic/fig ut-d/imagemap '))
  )]">

<!-- ===========================================================================
topic/figgroup
-->
<!ENTITY topic_area "*[
  name(.) = 'area' or contains(@class, ' topic/figgroup ut-d/area ')]">
<!ENTITY topic_figgroup "*[
  name(.) = 'figgroup' or (
  contains(@class, ' topic/figgroup ')
  and not(contains(@class, ' topic/figgroup ut-d/area '))
  )]">

<!-- ===========================================================================
topic/image
-->
<!ENTITY topic_image "*[name(.) = 'image' or contains(@class, ' topic/image ')]">

<!-- ===========================================================================
topic/itemgroup
-->
<!ENTITY topic_info "*[
  name(.) = 'info' or contains(@class, ' topic/itemgroup task/info ')]">
<!ENTITY topic_stepresult "*[
  name(.) = 'stepresult' or contains(@class, ' topic/itemgroup task/stepresult ')]">
<!ENTITY topic_stepxmp "*[
  name(.) = 'stepxmp' or contains(@class, ' topic/itemgroup task/stepxmp ')]">
<!ENTITY topic_tutorialinfo "*[
  name(.) = 'tutorialinfo' or contains(@class, ' topic/itemgroup task/tutorialinfo ')]">

<!-- ===========================================================================
topic/keyword
-->
<!ENTITY topic_cmdname "*[
  name(.) = 'cmdname' or contains(@class, ' topic/keyword sw-d/cmdname ')]">
<!ENTITY topic_shape "*[
  name(.) = 'shape' or contains(@class, ' topic/keyword ut-d/shape ')]">
<!ENTITY topic_shortcut "*[
  name(.) = 'shortcut' or contains(@class, ' topic/keyword ui-d/shortcut ')]">
<!ENTITY topic_varname "*[
  name(.) = 'varname' or contains(@class, ' topic/keyword sw-d/varname ')]">
<!ENTITY topic_wintitle "*[
  name(.) = 'wintitle' or contains(@class, ' topic/keyword sw-d/wintitle ')]">

<!-- ===========================================================================
topic/li
-->
<!ENTITY topic_choice "*[
  name(.) = 'choice' or contains(@class, ' topic/li task/choice ')]">
<!ENTITY topic_step "*[
  name(.) = 'step' or contains(@class, ' topic/li task/step ')]">
<!ENTITY topic_stepsection "*[
  name(.) = 'stepsection' or contains(@class, ' topic/li task/stepsection ')]">
<!ENTITY topic_substep "*[
  name(.) = 'substep' or contains(@class, ' topic/li task/substep ')]">
<!ENTITY topic_li "*[
  name(.) = 'li' or (
  contains(@class, ' topic/li ')
  and not(contains(@class, ' topic/li task/choice '))
  and not(contains(@class, ' topic/li task/step '))
  and not(contains(@class, ' topic/li task/stepsection '))
  and not(contains(@class, ' topic/li task/substep '))
  )]">
<!ENTITY topic_li_all "*[
  name(.) = 'li' or name(.) = 'choice' or name(.) = 'step' or
  name(.) = 'stepsection' or name(.) = 'substep' or
  contains(@class, ' topic/li ')
  ]">

<!-- ===========================================================================
topic/link
-->
<!ENTITY topic_link "*[name(.) = 'link' or contains(@class, ' topic/link ')]">

<!-- ===========================================================================
topic/linkinfo
-->
<!ENTITY topic_linkinfo "*[name(.) = 'linkinfo' or contains(@class, ' topic/linkinfo ')]">

<!-- ===========================================================================
topic/linklist
-->
<!ENTITY topic_linklist "*[name(.) = 'linklist' or contains(@class, ' topic/linklist ')]">

<!-- ===========================================================================
topic/linkpool
-->
<!ENTITY topic_linkpool "*[name(.) = 'linkpool' or contains(@class, ' topic/linkpool ')]">

<!-- ===========================================================================
topic/linktext
-->
<!ENTITY topic_linktext "*[name(.) = 'linktext' or contains(@class, ' topic/linktext ')]">

<!-- ===========================================================================
topic/navtitle
-->
<!ENTITY topic_navtitle "*[name(.) = 'navtitle' or contains(@class, ' topic/navtitle ')]">

<!-- ===========================================================================
topic/note
-->
<!ENTITY topic_note "*[name(.) = 'note' or contains(@class, ' topic/note ')]">

<!-- ===========================================================================
topic/object
-->
<!ENTITY topic_object "*[name(.) = 'object' or contains(@class, ' topic/object ')]">

<!-- ===========================================================================
topic/ol
-->
<!ENTITY topic_steps "*[
  name(.) = 'steps' or contains(@class, ' topic/ol task/steps ')]">
<!ENTITY topic_steps-unordered "*[
  name(.) = 'steps-unordered' or contains(@class, ' topic/ol task/steps-unordered ')]">
<!ENTITY topic_substeps "*[
  name(.) = 'substeps' or contains(@class, ' topic/ol task/substeps ')]">
<!ENTITY topic_ol "*[
  name(.) = 'ol' or (
  contains(@class, ' topic/ol ')
  and not(contains(@class, ' topic/ol task/steps '))
  and not(contains(@class, ' topic/ol task/steps-unordered '))
  and not(contains(@class, ' topic/ol task/substeps '))
)]">
<!ENTITY topic_ol_all "*[
  name(.) = 'ol' or name(.) = 'steps' or name(.) = 'steps-unordered' or name(.) = 'substeps' or
  contains(@class, ' topic/ol ')
  ]">

<!-- ===========================================================================
topic/p
-->
<!ENTITY topic_p "*[name(.) = 'p' or contains(@class, ' topic/p ')]">

<!-- ===========================================================================
topic/param
-->
<!ENTITY topic_param "*[name(.) = 'param' or contains(@class, ' topic/param ')]">

<!-- ===========================================================================
topic/ph
-->
<!ENTITY topic_b "*[
  name(.) = 'b' or contains(@class, ' topic/ph hi-d/b ')]">
<!ENTITY topic_cmd "*[
  name(.) = 'cmd' or contains(@class, ' topic/ph task/cmd ')]">
<!ENTITY topic_coords "*[
  name(.) = 'coords' or contains(@class, ' topic/ph ut-d/coords ')]">
<!ENTITY topic_codeph "*[
  name(.) = 'codeph' or contains(@class, ' topic/ph pr-d/codeph ')]">
<!ENTITY topic_filepath "*[
  name(.) = 'filepath' or contains(@class, ' topic/ph sw-d/filepath ')]">
<!ENTITY topic_i "*[
  name(.) = 'i' or contains(@class, ' topic/ph hi-d/i ')]">
<!ENTITY topic_mainbooktitle "*[
  name(.) = 'mainbooktitle' or contains(@class, ' topic/ph bookmap/mainbooktitle ')]">
<!ENTITY topic_menucascade "*[
  name(.) = 'menucascade' or contains(@class, ' topic/ph hi-d/menucascade ')]">
<!ENTITY topic_systemoutput "*[
  name(.) = 'systemoutput' or contains(@class, ' topic/ph sw-d/systemoutput ')]">
<!ENTITY topic_tt "*[
  name(.) = 'tt' or contains(@class, ' topic/ph hi-d/tt ')]">
<!ENTITY topic_u "*[
  name(.) = 'u' or contains(@class, ' topic/ph hi-d/u ')]">
<!ENTITY topic_uicontrol "*[
  name(.) = 'uicontrol' or contains(@class, ' topic/ph ui-d/uicontrol ')]">
<!ENTITY topic_userinput "*[
  name(.) = 'userinput' or contains(@class, ' topic/ph sw-d/userinput ')]">

<!-- ===========================================================================
topic/pre
-->
<!ENTITY topic_codeblock "*[
  name(.) = 'codeblock' or contains(@class, ' topic/pre pr-d/codeblock ')]">
<!ENTITY topic_screen "*[
  name(.) = 'screen' or contains(@class, ' topic/pre ui-d/screen ')]">
<!ENTITY topic_pre "*[
  name(.) = 'pre' or (
  contains(@class, ' topic/pre ')
  and not(contains(@class, ' topic/pre pr-d/codeblock '))
  and not(contains(@class, ' topic/pre ui-d/screen '))
  )]">
<!ENTITY topic_pre_all "*[
  name(.) = 'pre' or name(.) = 'codeblock' or name(.) = 'screen' or
  contains(@class, ' topic/pre ')
  ]">

<!-- ===========================================================================
topic/prolog
-->
<!ENTITY topic_prolog "*[name(.) = 'prolog' or contains(@class, ' topic/prolog ')]">

<!-- ===========================================================================
topic/publisher
-->
<!ENTITY topic_publisher "*[name(.) = 'publisher' or contains(@class, ' topic/publisher ')]">

<!-- ===========================================================================
topic/related-links
-->
<!ENTITY topic_related-links "*[name(.) = 'related-links' or contains(@class, ' topic/related-links ')]">

<!-- ===========================================================================
topic/section
-->
<!ENTITY topic_example "*[
  name(.) = 'example' or contains(@class, ' topic/section topic/example ')]">
<!ENTITY topic_context "*[
  name(.) = 'context' or contains(@class, ' topic/section task/context ')]">
<!ENTITY topic_postreq "*[
  name(.) = 'postreq' or contains(@class, ' topic/section task/postreq ')]">
<!ENTITY topic_prereq  "*[
  name(.) = 'prereq'  or contains(@class, ' topic/section task/prereq ')]">
<!ENTITY topic_refsyn  "*[
  name(.) = 'refsyn'  or contains(@class, ' topic/section reference/refsyn ')]">
<!ENTITY topic_result  "*[
  name(.) = 'result'  or contains(@class, ' topic/section task/result ')]">
<!ENTITY topic_steps-informal "*[
  name(.) = 'steps-informal'  or contains(@class, ' topic/section task/steps-informal ')]">
<!ENTITY topic_section "*[
  name(.) = 'section'  or (
  contains(@class, ' topic/section ')
  and not(contains(@class, ' topic/section topic/example '))
  and not(contains(@class, ' topic/section task/context '))
  and not(contains(@class, ' topic/section task/postreq '))
  and not(contains(@class, ' topic/section task/prereq '))
  and not(contains(@class, ' topic/section reference/refsyn '))
  and not(contains(@class, ' topic/section task/result '))
  and not(contains(@class, ' topic/section task/steps-informal '))
  )]">
<!ENTITY topic_section_all "*[
  name(.) = 'section' or name(.) = 'context' or name(.) = 'example' or
  name(.) = 'prereq'  or name(.) = 'postreq' or name(.) = 'refsyn'  or
  name(.) = 'result'  or name(.) = 'steps-informal' or
  contains(@class, ' topic/section ')
  ]">

<!-- ===========================================================================
topic/shortdesc
-->
<!ENTITY topic_shortdesc "*[name(.) = 'shortdesc' or contains(@class, ' topic/shortdesc ')]">

<!-- ===========================================================================
topic/simpletable
-->
<!ENTITY topic_simpletable "*[
  name(.) = 'simpletable' or name(.) = 'choicetable' or name(.) = 'properties' or
  contains(@class, ' topic/simpletable ')
  ]">

<!-- ===========================================================================
topic/sl
-->
<!ENTITY topic_sl "*[name(.) = 'sl' or contains(@class, ' topic/sl ')]">

 <!-- ===========================================================================
topic/sli
-->
<!ENTITY topic_sli "*[name(.) = 'sli' or contains(@class, ' topic/sli ')]">

<!-- ===========================================================================
topic/stentry
-->
<!ENTITY topic_stentry "*[
  name(.) = 'stentry'    or name(.) = 'chdesc'      or name(.) = 'chdeschd'   or
  name(.) = 'choption'   or name(.) = 'choptionhd'  or name(.) = 'propdesc'   or
  name(.) = 'proptype'   or name(.) = 'propvalue'   or name(.) = 'propdeschd' or
  name(.) = 'proptypehd' or name(.) = 'propvaluehd' or
  contains(@class, ' topic/stentry ')
  ]">

<!-- ===========================================================================
topic/sthead
-->
<!ENTITY topic_sthead "*[
  name(.) = 'sthead' or name(.) = 'chhead' or name(.) = 'prophead' or
  contains(@class, ' topic/sthead ')
  ]">

<!-- ===========================================================================
topic/strow
-->
<!ENTITY topic_strow "*[
  name(.) = 'strow' or name(.) = 'chrow' or name(.) = 'property' or
  contains(@class, ' topic/strow ')
  ]">

<!-- ===========================================================================
topic/text
-->
<!ENTITY topic_text "*[name(.) = 'text' or contains(@class, ' topic/text ')]">

<!-- ===========================================================================
topic/title
-->
<!ENTITY topic_booktitle "*[
  name(.) = 'booktitle' or contains(@class, ' topic/title bookmap/booktitle ')]">
<!ENTITY topic_title "*[
  name(.) = 'title' or (
  contains(@class, ' topic/title ')
  and not(contains(@class, ' topic/title bookmap/booktitle '))
  )]">
<!ENTITY topic_title_all "*[
  name(.) = 'title' or name(.) = 'booktitle' or
  contains(@class, ' topic/title ')
]">

<!-- ===========================================================================
topic/titlealts
-->
<!ENTITY topic_titlealts "*[name(.) = 'titlealts' or contains(@class, ' topic/titlealts ')]">

<!-- ===========================================================================
topic/topic
-->
<!ENTITY topic_topic "*[
  name(.) = 'topic' or name(.) = 'concept' or name(.) = 'reference' or
  name(.) = 'task' or
  contains(@class, ' topic/topic ')
  ]">
<!ENTITY topic_topic_all "*[
  name(.) = 'topic' or name(.) = 'concept' or name(.) = 'reference' or
  name(.) = 'task' or
  contains(@class, ' topic/topic ')
  ]">

<!-- ===========================================================================
topic/ul
-->
<!ENTITY topic_choices "*[
  name(.) = 'choices' or contains(@class, ' topic/ul task/choices ')]">
<!ENTITY topic_ul "*[
  name(.) = 'ul' or (
  contains(@class, ' topic/ul ')
  and not(contains(@class, ' topic/ul task/choices '))
  )]">
<!ENTITY topic_ul_all "*[
  name(.) = 'ul' or name(.) = 'choices' or
  contains(@class, ' topic/ul ')
  ]">

<!-- ===========================================================================
topic/xref
-->
<!ENTITY topic_xref "*[name(.) = 'xref' or contains(@class, ' topic/xref ')]">

