config.load_autoconfig()

c.url.start_pages = ["about:blank"]
c.url.default_page = "about:blank"
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "g": "https://www.google.com/search?q={}",
    "gh": "https://github.com/search?q={}",
}

c.tabs.show = "multiple"
c.tabs.position = "bottom"
c.tabs.background = True
c.tabs.select_on_remove = "last-used"
c.tabs.title.format = "{index}: {current_title}"

c.scrolling.smooth = True

c.colors.webpage.darkmode.enabled = True

c.editor.command = ["gram", "--new", "--wait", "--", "{file}:{line}:{column}"]

config.bind("tm", "config-cycle colors.webpage.darkmode.enabled")
config.bind(",c", "config-edit")

config.source("themes/brewer.py")
