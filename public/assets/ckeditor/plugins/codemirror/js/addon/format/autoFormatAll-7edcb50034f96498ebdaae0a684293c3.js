!function(){CodeMirror.defineExtension("autoFormatAll",function(e,n){for(var t=this,o=t.getMode(),r=t.getRange(e,n).split("\n"),i=CodeMirror.copyState(o,t.getTokenAt(e).state),a=t.getOption("tabSize"),l="",s=0,d=0==e.ch,g=0;g<r.length;++g){for(var c=new CodeMirror.StringStream(r[g],a);!c.eol();){var f=CodeMirror.innerMode(o,i),p=o.token(c,i),k=c.current();c.start=c.pos,(!d||/\S/.test(k))&&(l+=k,d=!1),!d&&f.mode.newlineAfterToken&&f.mode.newlineAfterToken(p,k,c.string.slice(c.pos)||r[g+1]||"",f.state)&&(l+="\n",d=!0,++s)}!c.pos&&o.blankLine&&o.blankLine(i),!d&&g<r.length-1&&(l+="\n",d=!0,++s)}t.operation(function(){t.replaceRange(l,e,n);for(var o=e.line+1,r=e.line+s;r>=o;++o)t.indentLine(o,"smart");t.setCursor({line:0,ch:0})})})}();