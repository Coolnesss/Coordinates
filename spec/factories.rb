FactoryGirl.define do
  factory :position do
    name "BestName"
    description "The best place on earth"
    lon 2774888.97595262
    lat 8435571.22109427
    votes 0
  end

  factory :report do
    cause "Useless"
    description "This site sucks"
    email "sam@random.com"
  end
end
