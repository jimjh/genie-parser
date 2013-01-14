# ~*~ encoding: utf-8 ~*~
require 'tmpdir'

module Spirit

  # Path to templates
  VIEWS = File.join File.dirname(__FILE__), *%w(.. .. views)

  # Markdown extensions for Redcarpet
  MARKDOWN_EXTENSIONS = {
    no_intra_emphasis:  true,
    tables:             true,
    fenced_code_blocks: true,
    autolink:           true,
    strikethrough:      true,
  }

  SOLUTION_DIR = Dir.tmpdir
  SOLUTION_EXT = '.sol'

  # Name of index page.
  INDEX     = 'index.md'

  # Name of manifest file.
  MANIFEST  = 'manifest.yml'

end
