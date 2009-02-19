if(typeof(Citeulike) == 'undefined') Citeulike = {}

Citeulike.Insert = {

   go: function() { 
        var table = document.getElementsByTagName('table');
		for (var i = 0, o; o = table[i]; i++) {
            for (var j = 0, u; u = o.attributes[j]; j++) {
                if( u.name.match(/title/i) && u.value.match(/Article Toolbox/i){
                    var anchor = document.createElement('a');
                    anchor.href = 'http://test.com';    
                    anchor.innerHTML = 'listen to me Rock!!';
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