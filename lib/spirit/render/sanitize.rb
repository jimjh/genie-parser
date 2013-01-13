# ~*~ encoding: utf-8 ~*~
require 'sanitize'

module Spirit

  module Render

    # Encapsulate sanitization options.
    # @see https://github.com/github/gollum/blob/master/lib/gollum/sanitization.rb
    class Sanitize < ::Sanitize

      # white-listed elements
      ELEMENTS = [
        'a', 'abbr', 'acronym', 'address', 'area', 'b', 'big',
        'blockquote', 'br', 'button', 'caption', 'center', 'cite',
        'code', 'col', 'colgroup', 'dd', 'del', 'dfn', 'dir',
        'div', 'dl', 'dt', 'em', 'fieldset', 'font', 'form', 'h1',
        'h2', 'h3', 'h4', 'h5', 'h6', 'hr', 'i', 'img', 'input',
        'ins', 'kbd', 'label', 'legend', 'li', 'map', 'menu',
        'ol', 'optgroup', 'option', 'p', 'pre', 'q', 's', 'samp',
        'select', 'small', 'span', 'strike', 'strong', 'sub',
        'sup', 'table', 'tbody', 'td', 'textarea', 'tfoot', 'th',
        'thead', 'tr', 'tt', 'u', 'ul', 'var'
      ].freeze

      # white-listed attributes
      ATTRIBUTES = {
        'a'   => ['href', 'name', 'data-magellan-destination'],
        'dd'  => ['data-magellan-arrival'],
        'dl'  => ['data-magellan-expedition'],
        'img' => ['src'],
        :all  => ['abbr', 'accept', 'accept-charset',
                  'accesskey', 'action', 'align', 'alt', 'axis',
                  'border', 'cellpadding', 'cellspacing', 'char',
                  'charoff', 'class', 'charset', 'checked', 'cite',
                  'clear', 'cols', 'colspan', 'color',
                  'compact', 'coords', 'datetime', 'dir',
                  'disabled', 'enctype', 'for', 'frame',
                  'headers', 'height', 'hreflang',
                  'hspace', 'id', 'ismap', 'label', 'lang',
                  'longdesc', 'maxlength', 'media', 'method',
                  'multiple', 'name', 'nohref', 'noshade',
                  'nowrap', 'prompt', 'readonly', 'rel', 'rev',
                  'rows', 'rowspan', 'rules', 'scope',
                  'selected', 'shape', 'size', 'span',
                  'start', 'summary', 'tabindex', 'target',
                  'title', 'type', 'usemap', 'valign', 'value',
                  'vspace', 'width']
      }.freeze

      # white-listed protocols
      PROTOCOLS = {
        'a'   => {'href' => ['http', 'https', 'mailto', 'ftp', 'irc', 'apt', :relative]},
        'img' => {'src'  => ['http', 'https', :relative]}
      }.freeze

      # elements to remove (incl. contents)
      REMOVE_CONTENTS = [
        'script',
        'style'
      ].freeze

      # attributes to add to elements
      ADD_ATTRIBUTES = {
        'a' => {'rel' => 'nofollow'}
      }

      # Creates a new sanitizer with {Spirit}'s configuration.
      def initialize
        super config
      end

      private

      # @return [Hash] configuration hash.
      def config
        { elements:         ELEMENTS.dup,
          attributes:       ATTRIBUTES.dup,
          protocols:        PROTOCOLS.dup,
          add_attributes:   ADD_ATTRIBUTES.dup,
          remove_contents:  REMOVE_CONTENTS.dup,
          allow_comments:   false
        }
      end

    end

  end

end
