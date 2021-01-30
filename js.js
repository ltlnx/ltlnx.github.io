var openmenu = {
	view: function() {
		return m("main", [
			m("a.class", {href:"posts.html"}, "貼文"),
			m("a.class", {href:"about.html"}, "關於我"),
			m("a.class", {href:"index.html"}, "回首頁"),
			m("a.class", {href:"#!/hello"}, "關閉選單"),
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