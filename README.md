# Spirit

Genie's parser, which parses the Genie Markup Language and produces HTML
partials. Both Aladdin and Lamp should depend on this gem for all their parsing
needs.

## Installation

Add this line to your application's Gemfile:

    gem 'spirit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spirit

## Usage

### Parsing a document

  Spirit::Document.new(data, opts).render //=> rendered html

### Parsing a manifest

  Spirit::Manifest.new(data, opts) //=> configuration object
