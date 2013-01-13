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

The only public api methods are `parse_document` and `parse_manifest`, which
parse lesson documents and manifests respectively. `Spirit::Error` exceptions
are raised if the input is invalid.
