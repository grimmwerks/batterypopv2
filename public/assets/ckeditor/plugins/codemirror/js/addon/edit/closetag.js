!function(){function e(e,r){var i=e.getCursor(),a=e.getTokenAt(i),s=CodeMirror.innerMode(e.getMode(),a.state),l=s.state;if("xml"!=s.mode.name)return CodeMirror.Pass;var d=e.getOption("autoCloseTags"),c="html"==s.mode.configuration,s="object"==typeof d&&d.dontCloseTags||c&&o,c="object"==typeof d&&d.indentTags||c&&n;if(">"==r&&l.tagName){d=l.tagName,a.end>i.ch&&(d=d.slice(0,d.length-a.end+i.ch));var f=d.toLowerCase();if("tag"==a.type&&"closeTag"==l.type||/\/\s*$/.test(a.string)||s&&-1<t(s,f))return CodeMirror.Pass;l=(a=c&&-1<t(c,f))?CodeMirror.Pos(i.line+1,0):CodeMirror.Pos(i.line,i.ch+1),e.replaceSelection(">"+(a?"\n\n":"")+"</"+d+">",{head:l,anchor:l}),a&&(e.indentLine(i.line+1),e.indentLine(i.line+2))}else{if("/"!=r||"<"!=a.string)return CodeMirror.Pass;(d=l.context&&l.context.tagName)&&e.replaceSelection("/"+d+">","end")}}function t(e,t){if(e.indexOf)return e.indexOf(t);for(var o=0,n=e.length;n>o;++o)if(e[o]==t)return o;return-1}CodeMirror.defineOption("autoCloseTags",!1,function(t,o,n){!o||n!=CodeMirror.Init&&n?!o&&n!=CodeMirror.Init&&n&&t.removeKeyMap("autoCloseTags"):(n={name:"autoCloseTags"},("object"!=typeof o||o.whenClosing)&&(n["'/'"]=function(t){return e(t,"/")}),("object"!=typeof o||o.whenOpening)&&(n["'>'"]=function(t){return e(t,">")}),t.addKeyMap(n))});var o="area base br col command embed hr img input keygen link meta param source track wbr".split(" "),n="applet blockquote body button div dl fieldset form frameset h1 h2 h3 h4 h5 h6 head html iframe layer legend object ol p select table ul".split(" ")}();