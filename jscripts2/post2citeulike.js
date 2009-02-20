if(typeof(Citeulike) == 'undefined') Citeulike = {}

Citeulike.Insert = {

   go: function() { 
        var table = document.getElementsByTagName('table');
		for (var i = 0, o; o = table[i]; i++) {
            for (var j = 0, u; u = o.attributes[j]; j++) {
                if( u.name == "title" && u.value == "Article Toolbox" ){
                    var anchor = document.createElement('a');
                    anchor.href = "javascript:var pw=window.open('http://www.citeulike.org/posturl?username=guillaume&bml=popup&url='+encodeURIComponent(location.href)+'&title='+encodeURIComponent(document.title), 'citeulike_popup_post', 'width=800,height=600,scrollbars=1,resizable=1'); void(window.setTimeout('pw.focus()',250));";    
                    anchor.innerHTML = '<img src="http://www.citeulike.org/favicon.ico" ></img>Post To CiteUlike';
                    var entry = document.createElement('td');
                    entry.appendChild(anchor);
                    var line = document.createElement('tr');
                    line.appendChild(entry);
                    var subtable = o.getElementsByTagName('table');
                    subtable[0].appendChild(line);
                }
            }
        }
    },
}

Citeulike.addLoadEvent = function(f) { var old = window.onload
	if (typeof old != 'function') window.onload = f
	else { window.onload = function() { old(); f() }}
}

Citeulike.addLoadEvent(Citeulike.Insert.go);
