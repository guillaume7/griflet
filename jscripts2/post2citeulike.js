if(typeof(Citeulike) == 'undefined') Citeulike = {}

Citeulike.Insert = {
   go: function() { 
        var div = document.getElementsByTagName('div');
		for (var i = 0, o; o = div[i]; i++) {
            if(o.id == "div1") {           
                var anchor = document.createElement('a');
                anchor.href = 'http://test.com'; 
                anchor.innerHTML = 'listen to me!!';
                var xdiv = document.createElement('div');
                xdiv.id = "external anchor";
                xdiv.appendChild(anchor);
                o.appendChild(anchor);
            }
        }
    },
    
   go2: function() { 
        var table = document.getElementsByTagName('table');
		for (var i = 0, o; o = table[i]; i++) {
            if(o.attributes[0].value == "5") {           
                var anchor = document.createElement('a');
                anchor.href = 'http://test.com'; 
                anchor.innerHTML = 'listen to me!!';
                var entry = document.createElement('td');
                entry.appendChild(anchor);
                var line = document.createElement('tr');
                line.appendChild(entry);
                o.appendChild(line);
            }
        }
    },

   go3: function() { 
        var table = document.getElementsByTagName('table');
		for (var i = 0, o; o = table[i]; i++) {
            for (var j = 0, u; u = o.attributes[j]; j++) {
                if( u.name == "title" && u.value == "Article Toolbox" ){
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

Citeulike.addLoadEvent(Citeulike.Insert.go3);