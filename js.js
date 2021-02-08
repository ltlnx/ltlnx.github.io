var baseURL = window.location.href.match(/(.*?)\.io/i)[1]+'.io';
var openMenu = {
	view: function() {
	return m("main.open", [
		m("a.horiz", {href:baseURL+"/index.html"}, "首頁"),
		m("a.horiz", {href:baseURL+"/about.html"}, "關於我"),
		m("a.horiz", {href:baseURL+"/posts/posts.html"}, "貼文"),
		])
	}
}
m.mount(document.getElementById("menu"), openMenu)


