CKEDITOR.skins.add("BootstrapCK-Skin",function(){var e="cke_ui_color";return{editor:{css:["editor.css"]},dialog:{css:["dialog.css"]},richcombo:{canGroup:!1},templates:{css:["templates.css"]},margins:[0,0,0,0],init:function(o){function t(o){var t=o.getById(e);return t||(t=o.getHead().append("style"),t.setAttribute("id",e),t.setAttribute("type","text/css")),t}function i(e,o,t){for(var i,r,c,n=0;n<e.length;n++)if(CKEDITOR.env.webkit)for(r=0;r<o.length;r++){for(c=o[r][1],i=0;i<t.length;i++)c=c.replace(t[i][0],t[i][1]);e[n].$.sheet.addRule(o[r][0],c)}else{for(c=o,i=0;i<t.length;i++)c=c.replace(t[i][0],t[i][1]);CKEDITOR.env.ie?e[n].$.styleSheet.cssText+=c:e[n].$.innerHTML+=c}}o.config.width&&!isNaN(o.config.width)&&(o.config.width-=12);var r=[],c="/* UI Color Support */.cke_skin_BootstrapCK-Skin .cke_menuitem .cke_icon_wrapper{	background-color: $color !important;	border-color: $color !important;}.cke_skin_BootstrapCK-Skin .cke_menuitem a:hover .cke_icon_wrapper,.cke_skin_BootstrapCK-Skin .cke_menuitem a:focus .cke_icon_wrapper,.cke_skin_BootstrapCK-Skin .cke_menuitem a:active .cke_icon_wrapper{	background-color: $color !important;	border-color: $color !important;}.cke_skin_BootstrapCK-Skin .cke_menuitem a:hover .cke_label,.cke_skin_BootstrapCK-Skin .cke_menuitem a:focus .cke_label,.cke_skin_BootstrapCK-Skin .cke_menuitem a:active .cke_label{	background-color: $color !important;}.cke_skin_BootstrapCK-Skin .cke_menuitem a.cke_disabled:hover .cke_label,.cke_skin_BootstrapCK-Skin .cke_menuitem a.cke_disabled:focus .cke_label,.cke_skin_BootstrapCK-Skin .cke_menuitem a.cke_disabled:active .cke_label{	background-color: transparent !important;}.cke_skin_BootstrapCK-Skin .cke_menuitem a.cke_disabled:hover .cke_icon_wrapper,.cke_skin_BootstrapCK-Skin .cke_menuitem a.cke_disabled:focus .cke_icon_wrapper,.cke_skin_BootstrapCK-Skin .cke_menuitem a.cke_disabled:active .cke_icon_wrapper{	background-color: $color !important;	border-color: $color !important;}.cke_skin_BootstrapCK-Skin .cke_menuitem a.cke_disabled .cke_icon_wrapper{	background-color: $color !important;	border-color: $color !important;}.cke_skin_BootstrapCK-Skin .cke_menuseparator{	background-color: $color !important;}.cke_skin_BootstrapCK-Skin .cke_menuitem a:hover,.cke_skin_BootstrapCK-Skin .cke_menuitem a:focus,.cke_skin_BootstrapCK-Skin .cke_menuitem a:active{	background-color: $color !important;}";if(CKEDITOR.env.webkit){c=c.split("}").slice(0,-1);for(var n=0;n<c.length;n++)c[n]=c[n].split("{")}var a=/\$color/g;CKEDITOR.tools.extend(o,{uiColor:null,getUiColor:function(){return this.uiColor},setUiColor:function(e){var n,k=t(CKEDITOR.document),s="."+o.id,_=[s+" .cke_wrapper",s+"_dialog .cke_dialog_contents",s+"_dialog a.cke_dialog_tab",s+"_dialog .cke_dialog_footer"].join(","),l="background-color: $color !important;";return n=CKEDITOR.env.webkit?[[_,l]]:_+"{"+l+"}",(this.setUiColor=function(e){var t=[[a,e]];o.uiColor=e,i([k],n,t),i(r,c,t)})(e)}}),o.on("menuShow",function(e){var n=e.data[0],k=n.element.getElementsByTag("iframe").getItem(0).getFrameDocument();if(!k.getById("cke_ui_color")){var s=t(k);r.push(s);var _=o.getUiColor();_&&i([s],c,[[a,_]])}}),o.config.uiColor&&o.setUiColor(o.config.uiColor)}}}()),function(){function e(){CKEDITOR.dialog.on("resize",function(e){var o=e.data,t=o.width,i=o.height,r=o.dialog,c=r.parts.contents;"BootstrapCK-Skin"==o.skin&&c.setStyles({width:t+"px",height:i+"px"})})}CKEDITOR.dialog?e():CKEDITOR.on("dialogPluginReady",e)}();