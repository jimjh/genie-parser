# ~*~ encoding: utf-8 ~*~
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
    tables:             true,
  }

  SOLUTION_DIR = Dir.tmpdir
  SOLUTION_EXT = '.sol'

end
