FactoryGirl.define do

  factory :problem, class: String do

    factory :table, class: String do
      format      'table'
      question    "fill me in"
      grid        [[0, "?", 2], [3, "?", 5]]
      answer      [["-", 1, "-"],  ["-", 4, "-"]]
    end

    factory :short, class: String do
      format      'short'
      answer      { Faker::Lorem.sentence }
      question    { Faker::Lorem.sentence }
    end

    factory :multi, class: String do
      format      'multi'
      answer      'B'
      question    { Faker::Lorem.sentence }
      options     'A' => 'a', 'B' => 'b', 'C' => 'c', 'D' => 'd'
    end

    initialize_with { attributes.delete_if { |k,v| v.nil? }.stringify_keys.to_yaml }
    to_create       {}

  end

end
