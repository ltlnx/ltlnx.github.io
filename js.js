var openmenu = {
	view: function() {
		return m("main", [
			m("a.class", {href:"javascript-test.html"}, "hello"),
			m("a.class", {href:"untitled.html"}, "about"),
			m("a.class", {href:"idk"}, "idk"),
			m("a.class", {href:"#!/hello"}, "close"),
			])
	}
}
var Hello = {
    view: function() {
        return m("main", [
            m("a", {href: "#!/menu"}, "menu"),
        ])
    }
}

m.route(document.getElementById("menu"), "/hello", {
	"/hello": Hello,
	"/menu": openmenu,
})