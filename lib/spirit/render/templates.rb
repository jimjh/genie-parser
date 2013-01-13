# ~*~ encoding: utf-8 ~*~

# require all template types
%w(template header image problem multi short table navigation).each do |type|
  require File.join 'spirit', 'render', 'templates', type
end
