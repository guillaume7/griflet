javascript:
popw='';
Q='';
x=document;
y=window;
if(x.selection) {
    Q=x.selection.createRange().text;
}
else if (y.getSelection) {
    Q=y.getSelection();
}
else if (x.getSelection) {
    Q=x.getSelection();
}
popw = y.open(
    'http://www.blogger.com/blog_this.pyra?t=' + escape(Q) + '&u=' + escape(location.href) + '&n=' + escape(document.title),
    'bloggerForm',
    'scrollbars=no,width=475,height=300,top=175,left=75,status=yes,resizable=yes'
);
if (!document.all) T = setTimeout('popw.focus()',50);
void(0);