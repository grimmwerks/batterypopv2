CodeMirror.defineMode("javascript",function(e,r){function t(e,r){for(var t,n=!1;null!=(t=e.next());){if(t==r&&!n)return!1;n=!n&&"\\"==t}return n}function n(e,r,t){return _=e,q=t,r}function a(e,r){var a=e.next();if('"'==a||"'"==a)return a=i(a),r.tokenize=a,a(e,r);if(/[\[\]{}\(\),;\:\.]/.test(a))return n(a);if("0"==a&&e.eat(/x/i))return e.eatWhile(/[\da-f]/i),n("number","number");if(/\d/.test(a)||"-"==a&&e.eat(/\d/))return e.match(/^\d*(?:\.\d*)?(?:[eE][+\-]?\d+)?/),n("number","number");if("/"==a)return e.eat("*")?(a=o,r.tokenize=a,a(e,r)):e.eat("/")?(e.skipToEnd(),n("comment","comment")):"operator"==r.lastType||"keyword c"==r.lastType||/^[\[{}\(,;:]$/.test(r.lastType)?(t(e,"/"),e.eatWhile(/[gimy]/),n("regexp","string-2")):(e.eatWhile(H),n("operator",null,e.current()));if("#"==a)return e.skipToEnd(),n("error","error");if(H.test(a))return e.eatWhile(H),n("operator",null,e.current());e.eatWhile(/[\w\$_]/);var a=e.current(),c=G.propertyIsEnumerable(a)&&G[a];return c&&"."!=r.lastType?n(c.type,c.style,a):n("variable","variable",a)}function i(e){return function(r,i){return t(r,e)||(i.tokenize=a),n("string","string")}}function o(e,r){for(var t,i=!1;t=e.next();){if("/"==t&&i){r.tokenize=a;break}i="*"==t}return n("comment","comment")}function c(e,r,t,n,a,i){this.indented=e,this.column=r,this.type=t,this.prev=a,this.info=i,null!=n&&(this.align=n)}function l(){for(var e=arguments.length-1;e>=0;e--)S.push(arguments[e])}function u(){return l.apply(null,arguments),!0}function s(e){function r(r){for(;r;r=r.next)if(r.name==e)return!0;return!1}var t=$;t.context?(A="def",r(t.localVars)||(t.localVars={name:e,next:t.localVars})):r(t.globalVars)||(t.globalVars={name:e,next:t.globalVars})}function f(){$.context={prev:$.context,vars:$.localVars},$.localVars=K}function p(){$.localVars=$.context.vars,$.context=$.context.prev}function d(e,r){var t=function(){var t=$;t.lexical=new c(t.indented,U.column(),e,null,t.lexical,r)};return t.lex=!0,t}function v(){var e=$;e.lexical.prev&&(")"==e.lexical.type&&(e.indented=e.lexical.indented),e.lexical=e.lexical.prev)}function m(e){return function(r){return r==e?u():";"==e?l():u(arguments.callee)}}function y(e){return"var"==e?u(d("vardef"),E,m(";"),v):"keyword a"==e?u(d("form"),b,y,v):"keyword b"==e?u(d("form"),y,v):"{"==e?u(d("}"),V,v):";"==e?u():"function"==e?u(O):"for"==e?u(d("form"),m("("),d(")"),I,m(")"),v,y,v):"variable"==e?u(d("stat"),g):"switch"==e?u(d("form"),b,d("}","switch"),m("{"),V,v,v):"case"==e?u(b,m(":")):"default"==e?u(m(":")):"catch"==e?u(d("form"),f,m("("),N,m(")"),y,v,p):l(d("stat"),b,m(";"),v)}function b(e){return J.hasOwnProperty(e)?u(h):"function"==e?u(O):"keyword c"==e?u(x):"("==e?u(d(")"),x,m(")"),v,h):"operator"==e?u(b):"["==e?u(d("]"),w(b,"]"),v,h):"{"==e?u(d("}"),w(M,"}"),v,h):u()}function x(e){return e.match(/[;\}\)\],]/)?l():l(b)}function h(e,r){if("operator"==e)return/\+\+|--/.test(r)?u(h):"?"==r?u(b,m(":"),b):u(b);if(";"!=e){if("("==e)return u(d(")"),w(b,")"),v,h);if("."==e)return u(k,h);if("["==e)return u(d("]"),b,m("]"),v,h)}}function g(e){return":"==e?u(v,y):l(h,m(";"),v)}function k(e){return"variable"==e?(A="property",u()):void 0}function M(e){return"variable"==e?A="property":("number"==e||"string"==e)&&(A=e+" property"),J.hasOwnProperty(e)?u(m(":"),b):void 0}function w(e,r){function t(n){return","==n?u(e,t):n==r?u():u(m(r))}return function(n){return n==r?u():l(e,t)}}function V(e){return"}"==e?u():l(y,V)}function j(e){return":"==e?u(T):l()}function T(e){return"variable"==e?(A="variable-3",u()):l()}function E(e,r){return"variable"==e?(s(r),F?u(j,C):u(C)):l()}function C(e,r){return"="==r?u(b,C):","==e?u(E):void 0}function I(e){return"var"==e?u(E,m(";"),P):";"==e?u(P):"variable"==e?u(z):u(P)}function z(e,r){return"in"==r?u(b):u(h,P)}function P(e,r){return";"==e?u(W):"in"==r?u(b):u(b,m(";"),W)}function W(e){")"!=e&&u(b)}function O(e,r){return"variable"==e?(s(r),u(O)):"("==e?u(d(")"),f,w(N,")"),v,y,p):void 0}function N(e,r){return"variable"==e?(s(r),F?u(j):u()):void 0}var S,$,A,U,_,q,B=e.indentUnit,D=r.json,F=r.typescript,G=function(){function e(e){return{type:e,style:"keyword"}}var r=e("keyword a"),t=e("keyword b"),n=e("keyword c"),a=e("operator"),i={type:"atom",style:"atom"},r={"if":r,"while":r,"with":r,"else":t,"do":t,"try":t,"finally":t,"return":n,"break":n,"continue":n,"new":n,"delete":n,"throw":n,"var":e("var"),"const":e("var"),let:e("var"),"function":e("function"),"catch":e("catch"),"for":e("for"),"switch":e("switch"),"case":e("case"),"default":e("default"),"in":a,"typeof":a,"instanceof":a,"true":i,"false":i,"null":i,undefined:i,NaN:i,Infinity:i};if(F){var o,t={type:"variable",style:"variable-3"},t={"interface":e("interface"),"class":e("class"),"extends":e("extends"),constructor:e("constructor"),"public":e("public"),"private":e("private"),"protected":e("protected"),"static":e("static"),"super":e("super"),string:t,number:t,bool:t,any:t};for(o in t)r[o]=t[o]}return r}(),H=/[+\-*&%=<>!?|]/,J={atom:!0,number:!0,variable:!0,string:!0,regexp:!0};S=A=$=null,U=void 0;var K={name:"this",next:{name:"arguments"}};return v.lex=!0,{startState:function(e){return{tokenize:a,lastType:null,cc:[],lexical:new c((e||0)-B,0,"block",!1),localVars:r.localVars,globalVars:r.globalVars,context:r.localVars&&{vars:r.localVars},indented:0}},token:function(e,r){if(e.sol()&&(r.lexical.hasOwnProperty("align")||(r.lexical.align=!1),r.indented=e.indentation()),e.eatSpace())return null;var t=r.tokenize(e,r);if("comment"==_)return t;r.lastType=_;var n;e:{var a=_,i=q,o=r.cc;for($=r,U=e,A=null,S=o,r.lexical.hasOwnProperty("align")||(r.lexical.align=!0);;)if((o.length?o.pop():D?b:y)(a,i)){for(;o.length&&o[o.length-1].lex;)o.pop()();if(A){n=A;break e}if(n="variable"==a)r:{for(n=r.localVars;n;n=n.next)if(n.name==i){n=!0;break r}n=void 0}if(n){n="variable-2";break e}n=t;break e}}return n},indent:function(e,r){if(e.tokenize==o)return CodeMirror.Pass;if(e.tokenize!=a)return 0;var t=r&&r.charAt(0),n=e.lexical;"stat"==n.type&&"}"==t&&(n=n.prev);var i=n.type,c=t==i;return"vardef"==i?n.indented+("operator"==e.lastType||","==e.lastType?4:0):"form"==i&&"{"==t?n.indented:"form"==i?n.indented+B:"stat"==i?n.indented+("operator"==e.lastType||","==e.lastType?B:0):"switch"!=n.info||c?n.align?n.column+(c?0:1):n.indented+(c?0:B):n.indented+(/^(?:case|default)\b/.test(r)?B:2*B)},electricChars:":{}",jsonMode:D}}),CodeMirror.defineMIME("text/javascript","javascript"),CodeMirror.defineMIME("text/ecmascript","javascript"),CodeMirror.defineMIME("application/javascript","javascript"),CodeMirror.defineMIME("application/ecmascript","javascript"),CodeMirror.defineMIME("application/json",{name:"javascript",json:!0}),CodeMirror.defineMIME("text/typescript",{name:"javascript",typescript:!0}),CodeMirror.defineMIME("application/typescript",{name:"javascript",typescript:!0});