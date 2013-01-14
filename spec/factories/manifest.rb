# ~*~ encoding: utf-8 ~*~
FactoryGirl.define do

  factory :manifest, class: Hash do
    title           { Faker::Lorem.sentence }
    description     { Faker::Lorem.paragraph }
    categories      { Faker::Lorem.words }
    static_paths    { Faker::Lorem.words }
    initialize_with { attributes }
    verify          Hash['bin' => Faker::Lorem.word, 'arg_prefix' => Faker::Lorem.word]
    to_create       {}
  end

end
