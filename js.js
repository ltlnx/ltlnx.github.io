var baseURL = window.location.href.match(/(.*?)\.io/i)[1]+'.io'
var openmenu = {
	view: function() {
		return m("main.open", [
			m("a.open", {href:baseURL+"/posts/posts.html"}, "貼文"),
			m("a.open", {href:baseURL+"/about.html"}, "關於我"),
			m("a.open", {href:baseURL+"/index.html"}, "回首頁"),
			m("a.open", {href:"#!/hello"}, "關閉選單"),
			])
	}
}
var Hello = {
    view: function() {
        return m("main", [
            m("a", {href: "#!/menu"}, "選單"),
        ])
    }
}

m.route(document.getElementById("menu"), "/hello", {
	"/hello": Hello,
	"/menu": openmenu,
})