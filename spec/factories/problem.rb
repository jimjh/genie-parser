FactoryGirl.define do

  factory :problem, class: String do

    factory :table, class: String do
      format      'table'
      answer      { Faker::Lorem.sentence }
      question    { Faker::Lorem.sentence }
    end

    factory :short, class: String do
      format      'short'
      answer      { Faker::Lorem.sentence }
      question    { Faker::Lorem.sentence }
    end

    initialize_with { attributes.delete_if { |k,v| v.nil? }.stringify_keys.to_yaml }
    to_create       {}

  end

end
