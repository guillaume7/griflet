if(typeof(Citeulike) == 'undefined') Citeulike = {}
<a onmouseout="document.images['addEmail'].src='/scidirimg/sci_dir/emailarticle_a.gif'" onmouseover="document.images['addEmail'].src='/scidirimg/sci_dir/emailarticle_b.gif'" style="vertical-align: bottom; color: rgb(0, 0, 0); font-family: arial,verdana,helvetica,sans-serif; text-decoration: none;" href="/science?_ob=EmailFriendURL&_method=gatherInfo&_ArticleListID=869795052&refSource=html&count=1&_uoikey=B6VCR-4T9CCSY-2&_acct=C000057394&_version=1&_userid=2459750&md5=517beb052ed9a2be270d78071a27cebc">
  E-mail Article
</a>
Citeulike.Insert = {

   go: function() { 
        var table = document.getElementsByTagName('table');
		for (var i = 0, o; o = table[i]; i++) {
            for (var j = 0, u; u = o.attributes[j]; j++) {
                if( u.name == "title" && u.value == "Article Toolbox" ){
                    var anchor = document.createElement('a');
                    anchor.href = 'http://test.com';
                    anchor.innerHTML = '<img alt="" name="postCiteulike" src="http://www.citeulike.org/favicon.ico"/>Post to CiteULike';
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