!function(){function e(e){return"string"==typeof e?{token:function(o){return o.match(e)?"searching":(o.next(),o.skipTo(e.charAt(0))||o.skipToEnd(),void 0)}}:{token:function(o){if(o.match(e))return"searching";for(;!o.eol()&&(o.next(),!o.match(e,!1)););}}}function o(){this.overlay=this.posFrom=this.posTo=this.query=null}function r(e,o,r){return e.getSearchCursor(o,r,"string"==typeof o&&o==o.toLowerCase())}function t(e,o,r,t){e.openDialog?e.openDialog(o,t):t(prompt(r,""))}function n(e,o,r,t){e.openConfirm?e.openConfirm(o,t):confirm(r)&&t[0]()}function i(e){var o=e.match(/^\/(.*)\/([a-z]*)$/);return o?RegExp(o[1],-1==o[2].indexOf("i")?"":"i"):e}function a(r,n){var a=r._searchState||(r._searchState=new o);return a.query?c(r,n):(t(r,u,"Search for:",function(o){r.operation(function(){o&&!a.query&&(a.query=i(o),r.removeOverlay(a.overlay),a.overlay=e(o),r.addOverlay(a.overlay),a.posFrom=a.posTo=r.getCursor(),c(r,n))})}),void 0)}function c(e,t){e.operation(function(){var n=e._searchState||(e._searchState=new o),i=r(e,n.query,t?n.posFrom:n.posTo);(i.find(t)||(i=r(e,n.query,t?CodeMirror.Pos(e.lastLine()):CodeMirror.Pos(e.firstLine(),0)),i.find(t)))&&(e.setSelection(i.from(),i.to()),n.posFrom=i.from(),n.posTo=i.to())})}function f(e){e.operation(function(){var r=e._searchState||(e._searchState=new o);r.query&&(r.query=null,e.removeOverlay(r.overlay))})}function s(e,o){t(e,p,"Replace:",function(a){a&&(a=i(a),t(e,l,"Replace with:",function(t){if(o)e.operation(function(){for(var o=r(e,a);o.findNext();)if("string"!=typeof a){var n=e.getRange(o.from(),o.to()).match(a);o.replace(t.replace(/\$(\d)/,function(e,o){return n[o]}))}else o.replace(t)});else{f(e);var i=r(e,a,e.getCursor()),c=function(){var o,t=i.from();!(o=i.findNext())&&(i=r(e,a),!(o=i.findNext())||t&&i.from().line==t.line&&i.from().ch==t.ch)||(e.setSelection(i.from(),i.to()),n(e,m,"Replace?",[function(){s(o)},c]))},s=function(e){i.replace("string"==typeof a?t:t.replace(/\$(\d)/,function(o,r){return e[r]})),c()};c()}}))})}var u='Search: <input type="text" style="width: 10em"/> <span style="color: #888">(Use /re/ syntax for regexp search)</span>',p='Replace: <input type="text" style="width: 10em"/> <span style="color: #888">(Use /re/ syntax for regexp search)</span>',l='With: <input type="text" style="width: 10em"/>',m="Replace? <button>Yes</button> <button>No</button> <button>Stop</button>";CodeMirror.commands.find=function(e){f(e),a(e)},CodeMirror.commands.findNext=a,CodeMirror.commands.findPrev=function(e){a(e,!0)},CodeMirror.commands.clearSearch=f,CodeMirror.commands.replace=s,CodeMirror.commands.replaceAll=function(e){s(e,!0)}}();