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

c.editor.command = ["cosmic-term", "--command", "hx", "--", "{file}:{line}:{column}"]

# Open link in new tab
config.bind("tt", "open --tab")

# Duplicate tab
config.bind("td", "tab-clone")

# Close tab
config.bind("<Ctrl-w>", "tab-close")

# Reopen closed tab
config.bind("U", "undo")

# Quick bookmark add
config.bind("bb", "bookmark-add")

# Toggle dark mode
config.bind("tm", "config-cycle colors.webpage.darkmode.enabled")

# Open config quickly
config.bind(",c", "config-edit")
