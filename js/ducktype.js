/*
Language: Ducktype
Author: Shaun McCance <shaunm@gnome.org>
Website: https://twitter.com/shaunm
Category: markup
*/

/** @type LanguageFn */
export default function(hljs) {
  var ATTRLIST = {
    endsWithParent: true,
    relevance: 0,
    contains: [
      {
        className: 'attr',
        begin: />>[^\]\s]+/
      },
      {
        className: 'attr',
        begin: /(\.|#|>)?[A-Za-z0-9\._:#-]+/
      },
      {
        begin: /=/,
        relevance: 0,
        contains: [
          {
            className: 'string',
            endsParent: true,
            variants: [
              { begin: /"/, end: /"/ },
              { begin: /'/, end: /'/ },
              {begin: /[^\s"'\]]+/}
            ]
          }
        ]
      }
    ]
  };
  return {
    aliases: ['duck'],
    contains: [
      {
        className: 'section',
        variants: [
          { begin: /^=+ /, end: /$/ },
          { begin: /^-+ /, end: /$/ },
        ]
      },
      /* comments come in two forms: [-- fenced --] and [-] line */
      hljs.COMMENT(
        /^ *\[--/,
        /^ *--\]$/,
        { relevance: 10 }
      ),
      hljs.COMMENT(
        /^ *\[-\]/,
        /$/,
        { relevance: 10 }
      ),
      /* no-parse fences are enclosed in [[[ triple brackets ]]] */
      {
        className: 'code',
        begin: /^ *\[\[\[$/,
        end: /^ *\]\]\]$/,
        relevance: 10
      },
      /* block tags [look like=this] */
      {
        className: 'tag',
        begin: /^ *\[/,
        end: /\]$/,
        contains: [
          {
            className: 'name',
            begin: /[A-Za-z0-9\._:-]+/,
            relevance: 0
          },
          ATTRLIST
        ]
      },
      /* entity $references; */
      {
        className: 'tag',
        begin: /\$[a-zA-Z0-9][a-zA-Z0-9:]*;/
      },
      /* info elements are tagged @like[this] */
      {
        className: 'tag',
        begin: /^ *@[a-zA-Z][a-zA-Z:]*\[/,
        end: /\]/,
        contains: [
          ATTRLIST
        ]
      },
      /* parser directives look like info elements, but have a looser
         syntax. need to match them after info elements */
      {
        className: 'tag',
        begin: /^ *@/,
        end: /$/
      },
      /* inline element are tagged $like[this](and this) */
      {
        className: 'tag',
        begin: /\$[a-zA-Z][a-zA-Z:]*\[/,
        end: /\]/,
        contains: [
          ATTRLIST
        ]
      }
    ]
  };
}
