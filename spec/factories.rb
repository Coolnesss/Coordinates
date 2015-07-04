require 'rack/test'

FactoryGirl.define do
  factory :position do
    name "BestName"
    description "The best place on earth"
    lon 2774888.97595262
    lat 8435571.22109427
    votes 0
    email "chang@best.fi"
  end

  factory :report do
    cause "Useless"
    description "This site sucks"
    email "sam@random.com"
    ignored false
    position
  end

  factory :user do
    username "Sam"
    password "Samisbest"
    password_confirmation "Samisbest"
  end

  factory :picture do
    image { Rack::Test::UploadedFile.new(:tempfile => Rails.root + 'spec/helpers/missing.png', :filename => 'missing.png') }
    #image { (Rails.root.join('test', 'fixtures', 'missing.png'), 'image/png') }
  end
end
