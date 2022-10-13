using Documenter
using Interactive_HT

makedocs(
    sitename = "Interactive_HT",
    format = Documenter.HTML(),
    modules = [Interactive_HT]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
