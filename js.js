var baseURL = window.location.href.match(/(.*?)\.io/i)[1]+'.io';
var width = this.innerWidth || this.document.documentElement.clientWidth || this.document.body.clientWidth || 0;
var openMenu = {
	view: function() {
	return m("main.open", [
		m("a.open", {href:baseURL+"/posts/posts.html"}, "貼文"),
		m("a.open", {href:baseURL+"/about.html"}, "關於我"),
		m("a.open", {href:baseURL+"/index.html"}, "回首頁"),
		m("a.open.close", {href:"#!/collapsed"}, "關閉選單")
		])
	}
}
var collapsed = {
    view: function() {
        return m("main", [
            m("a", {href: "#!/menu"}, "選單"),
        ])
    }
}
if( width > 600 ) {
	m.mount(document.getElementById("menu"), openMenu)
} else {
	m.route(document.getElementById("menu"), "/collapsed", {
		"/collapsed": collapsed,
		"/menu": openMenu,
	})
}

