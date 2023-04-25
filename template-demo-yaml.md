url: 'https://nonprofit-open-data-collective.github.io/compensator/'

template:
  bootstrap: 5
  bootswatch: sandstone
  bslib:
    pkgdown-nav-height: 100px
    bg: "white"
    fg: "#283140"
    primary: "#1b6ada"
    dropdown-link-hover-bg: "#64a4ef"
    dropdown-link-hover-color: "white"
    dropdown-link-active-color: "white"
    headings-color: "#5c677e"
    navbar-brand-font-size: "2rem"
    navbar-light-color: "white"
    navbar-light-brand-color: "white"
    navbar-light-brand-hover-color: "white"
    text-muted: "#54585F"
    navbar-light-hover-color: "white"
    gray-300: "#dee2e6"
    border-radius: 0.5rem
    btn-border-radius: 0.25rem
    base_font: "proxima-nova,sans-serif"

navbar:
  structure:
    left:  [intro, articles, reference]
    right: [github]

development:
  mode: auto

articles:
  - title: "Getting Started"
    desc: >
      These vignettes provide .....
    contents:
      - test-vig
      - ntee-codes
