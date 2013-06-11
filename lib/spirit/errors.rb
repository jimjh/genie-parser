module Spirit

  # The base exception for all {Spirit} errors. Raised if the parser is unable
  # to continue.
  class Error < StandardError; end

  class DocumentError < Error; end

  class ManifestError < Error; end

end
