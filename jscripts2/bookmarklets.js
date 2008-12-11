javascript:(
    function(){
        d=document.getSelection();
        if (!d) d=encodeURIComponent(document.title);
        t=prompt('Tags:');
        setTimeout('TheNewWin.close();',10000);
        TheNewWin=open(
        'https://api.del.icio.us/v1/posts/add?description='+d+'&tags='+escape(t)+'&url='+window.location.href,'delicious','toolbar=no,width=100,height=100');
        TheNewWin.blur();
    }
)()

javascript:
popw=window.open('','Delicious Tarpipe micro-post','width=600,height=300');
popw.focus();
popd=popw.document;
popd.write('<form action="http://rest.receptor.tarpipe.net:8000/?key="YOUR_KEY_HERE" method="POST" enctype="multipart/form-data">');
popd.write('Description <input type="text" size="70" name="title" value="'+document.title+'"/><br/>');
popd.write('Url <input type="text" size="70" name="url" value="'+location.href+'"/><br/>');
popd.write('Tags <input type="text" size="70" name="body" value=""/><br/>');
popd.write('<input type="submit" name="Submit" value="bookmark it !"/>');
popd.write('</form>');

javascript:popw=window.open('','Delicious Tarpipe micro-post','width=600,height=300');popw.focus();popd=popw.document;popd.write('<form action="http://rest.receptor.tarpipe.net:8000/?key="YOUR_KEY_HERE" method="POST" enctype="multipart/form-data">');popd.write('Description <input type="text" size="70" name="title" value="'+document.title+'"/><br/>');popd.write('Url <input type="text" size="70" name="url" value="'+location.href+'"/><br/>');popd.write('Tags <input type="text" size="70" name="body" value=""/><br/>');popd.write('<input type="submit" name="Submit" value="bookmark it !"/>');popd.write('</form>');

javascript:popw=window.open('','Delicious Tarpipe micro-post','width=600,height=300');popw.focus();popd=popw.document;popd.write('<form action="http://tarpipe.com" method="POST" enctype="multipart/form-data">');popd.write('Tags <input type="text" size="70" name="body" value=""/>');popd.write('<input type="submit" name="Submit" value="bookmark it !"/>');popd.write('</form>');

k='PUT_YOUR_KEY_HERE';s=document.getSelection();t=document.title;if (!s) s=encodeURIComponent(t);

javascript:
k='PUT_YOUR_KEY_HERE';
w='500';h='60';x='72';g='30';u='25';
s=document.getSelection();
t=document.title;
if (!s) s=t;
n=window.open('','Tarpipe bookmarklet','width='+w+',height='+h);
n.focus();
d=n.document;
d.write('<form action="http://rest.receptor.tarpipe.net:8000/?key='+k+'" method="POST" enctype="multipart/form-data">');
d.write('Txt <input type="text" size="'+x+'" name="title" value="'+s+'" maxlength="140"/><br/>');
d.write('Tags <input type="text" size="'+g+'" name="body" value="'+t+'"/> ');
d.write('Url <input type="text" size="'+u+'" name="url" value="'+location.href+'"/>');
d.write('<input type="submit" name="Submit" value="pipe"/>');
d.write('</form>');

javascript:k='PUT_YOUR_KEY_HERE';w='500';h='60';x='72';g='30';u='25';s=document.getSelection();t=document.title;if (!s) s=t;n=window.open('','Tarpipe bookmarklet','width='+w+',height='+h);n.focus();d=n.document;d.write('<form action="http://rest.receptor.tarpipe.net:8000/?key='+k+'" method="POST" enctype="multipart/form-data">');d.write('Txt <input type="text" size="'+x+'" name="title" value="'+s+'" maxlength="140"/><br/>');d.write('Tags <input type="text" size="'+g+'" name="body" value="'+t+'"/> ');d.write('Url <input type="text" size="'+u+'" name="url" value="'+location.href+'"/>');d.write('<input type="submit" name="Submit" value="pipe"/>');d.write('</form>');
