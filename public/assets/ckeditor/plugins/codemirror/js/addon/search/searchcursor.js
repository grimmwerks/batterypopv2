!function(){function e(e,n,i,o){if(this.atOccurrence=!1,this.cm=e,null==o&&"string"==typeof n&&(o=!1),i=i?e.clipPos(i):t(0,0),this.pos={from:i,to:i},"string"!=typeof n)n.global||(n=RegExp(n.source,n.ignoreCase?"ig":"g")),this.matches=function(i,o){if(i){n.lastIndex=0;for(var r=e.getLine(o.line).slice(0,o.ch),s=n.exec(r),h=0;s;){h+=s.index+1,r=r.slice(h),n.lastIndex=0;var c=n.exec(r);if(!c)break;s=c}h--}else n.lastIndex=o.ch,r=e.getLine(o.line),h=(s=n.exec(r))&&s.index;return s&&s[0]?{from:t(o.line,h),to:t(o.line,h+s[0].length),match:s}:void 0};else{o&&(n=n.toLowerCase());var r=o?function(e){return e.toLowerCase()}:function(e){return e},s=n.split("\n");this.matches=1==s.length?n.length?function(i,o){var s,h=r(e.getLine(o.line)),c=n.length;return(i?o.ch>=c&&-1!=(s=h.lastIndexOf(n,o.ch-c)):-1!=(s=h.indexOf(n,o.ch)))?{from:t(o.line,s),to:t(o.line,s+c)}:void 0}:function(){}:function(n,i){var o=i.line,h=n?s.length-1:0,c=s[h],l=r(e.getLine(o)),f=n?l.indexOf(c)+c.length:l.lastIndexOf(c);if(!(n?f>=i.ch||f!=c.length:f<=i.ch||f!=l.length-c.length))for(;!(n?!o:o==e.lineCount()-1);){if(l=r(e.getLine(o+=n?-1:1)),c=s[n?--h:++h],!(h>0&&h<s.length-1)){if(h=n?l.lastIndexOf(c):l.indexOf(c)+c.length,n?h!=l.length-c.length:h!=c.length)break;return c=t(i.line,f),o=t(o,h),{from:n?o:c,to:n?c:o}}if(l!=c)break}}}}var t=CodeMirror.Pos;e.prototype={findNext:function(){return this.find(!1)},findPrevious:function(){return this.find(!0)},find:function(e){function n(e){return e=t(e,0),i.pos={from:e,to:e},i.atOccurrence=!1}for(var i=this,o=this.cm.clipPos(e?this.pos.from:this.pos.to);;){if(this.pos=this.matches(e,o))return(!this.pos.from||!this.pos.to)&&console.log(this.matches,this.pos),this.atOccurrence=!0,this.pos.match||!0;if(e){if(!o.line)return n(0);o=t(o.line-1,this.cm.getLine(o.line-1).length)}else{var r=this.cm.lineCount();if(o.line==r-1)return n(r);o=t(o.line+1,0)}}},from:function(){return this.atOccurrence?this.pos.from:void 0},to:function(){return this.atOccurrence?this.pos.to:void 0},replace:function(e){this.atOccurrence&&(e=CodeMirror.splitLines(e),this.cm.replaceRange(e,this.pos.from,this.pos.to),this.pos.to=t(this.pos.from.line+e.length-1,e[e.length-1].length+(1==e.length?this.pos.from.ch:0)))}},CodeMirror.defineExtension("getSearchCursor",function(t,n,i){return new e(this,t,n,i)})}();