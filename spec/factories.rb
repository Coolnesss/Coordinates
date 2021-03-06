require 'rack/test'

FactoryGirl.define do
  factory :position do
    name "BestName"
    description "The best place on earth"
    lon 24.91840286970849
    lat 60.1788711197085
    votes 0
    email "chang@best.fi"
    fb_id 1154034356884883
    category "Talvikunnossapito, Lumikasa väylällä"
  end

  factory :report do
    cause "fixed"
    description "This site sucks"
    email "sam@random.com"
    ignored false
    fb_id 1154034356884883
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
