!function(){function t(t){function e(e,n,r){if(e.text){var i=f?0:e.text.length-1,a=f?e.text.length:-1;for(null!=r&&(i=r+l);i!=a;i+=l)if(r=e.text.charAt(i),m.test(r)&&t.getTokenAt(o(n,i+1)).type==h){var u=c[r];if(">"==u.charAt(1)==f)s.push(r);else{if(s.pop()!=u.charAt(0))return{pos:i,match:!1};if(!s.length)return{pos:i,match:!0}}}}}var n=t.getCursor(),r=t.getLineHandle(n.line),i=n.ch-1,a=i>=0&&c[r.text.charAt(i)]||c[r.text.charAt(++i)];if(!a)return null;for(var u,f=">"==a.charAt(1),l=f?1:-1,h=t.getTokenAt(o(n.line,i+1)).type,s=[r.text.charAt(i)],m=/[(){}[\]]/,a=n.line,d=f?Math.min(a+100,t.lineCount()):Math.max(-1,a-100);a!=d&&!(u=a==n.line?e(r,a,i):e(t.getLineHandle(a),a));a+=l);return{from:o(n.line,i),to:u&&o(a,u.pos),match:u&&u.match}}function e(e,n){var c=t(e);if(c&&!(e.getLine(c.from.line).length>i||c.to&&e.getLine(c.to.line).length>i)){var a=c.match?"CodeMirror-matchingbracket":"CodeMirror-nonmatchingbracket",u=e.markText(c.from,o(c.from.line,c.from.ch+1),{className:a}),f=c.to&&e.markText(c.to,o(c.to.line,c.to.ch+1),{className:a});if(r&&e.state.focused&&e.display.input.focus(),c=function(){e.operation(function(){u.clear(),f&&f.clear()})},!n)return c;setTimeout(c,800)}}function n(t){t.operation(function(){a&&(a(),a=null),t.somethingSelected()||(a=e(t,!1))})}var r=/MSIE \d/.test(navigator.userAgent)&&(null==document.documentMode||8>document.documentMode),o=CodeMirror.Pos,i=1e3,c={"(":")>",")":"(<","[":"]>","]":"[<","{":"}>","}":"{<"},a=null;CodeMirror.defineOption("matchBrackets",!1,function(t,e){e?t.on("cursorActivity",n):t.off("cursorActivity",n)}),CodeMirror.defineExtension("matchBrackets",function(){e(this,!0)}),CodeMirror.defineExtension("findMatchingBracket",function(){return t(this)})}();