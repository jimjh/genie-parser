# Spirit
[![Dependency Status](https://gemnasium.com/jimjh/genie-parser.png)](https://gemnasium.com/jimjh/genie-parser)
[![Code Climate](https://codeclimate.com/github/jimjh/genie-parser.png)](https://codeclimate.com/github/jimjh/genie-parser)
[![Build Status](https://travis-ci.org/jimjh/genie-parser.png)](https://travis-ci.org/jimjh/genie-parser)

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

```rb
Spirit::Document.new(data, opts).render //=> rendered html
```

### Parsing a manifest

```rb
Spirit::Manifest.new(data, opts) //=> configuration object
```
