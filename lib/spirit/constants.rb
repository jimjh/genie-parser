require 'tmpdir'

module Spirit

  # Path to templates
  VIEWS = File.join(File.dirname(__FILE__), *%w(.. .. views)).freeze

  # Markdown extensions for Redcarpet
  MARKDOWN_EXTENSIONS = {
    no_intra_emphasis:  true,
    tables:             true,
    fenced_code_blocks: true,
    autolink:           true,
    strikethrough:      true,
  }.freeze

  # Renderer configuration options
  RENDERER_CONFIG = {
    hard_wrap:          true,
    no_styles:          true,
  }.freeze

  HAML_CONFIG = {
    escape_html:        true,
    format:             :html5,
  }.freeze

  SOLUTION_DIR = Dir.tmpdir.freeze
  SOLUTION_EXT = '.sol'.freeze

  # Name of index page.
  INDEX     = 'index.md'.freeze

  # Name of manifest file.
  MANIFEST  = 'manifest.yml'.freeze

end
