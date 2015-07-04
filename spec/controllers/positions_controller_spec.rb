require 'rails_helper'

RSpec.describe PositionsController, :type => :controller do
  describe "POST create" do

    before(:each) do
      AWS.stub!
      file = File.new(Rails.root.join('spec/helpers/missing.png'))
      @image = Picture.new(:image => ActionDispatch::Http::UploadedFile.new(:tempfile => file, :filename => File.basename(file)))
      file.close
      @image.save

      file = File.new(Rails.root.join('spec/helpers/woodpecker.png'))
      @imagetwo = Picture.new(:image => ActionDispatch::Http::UploadedFile.new(:tempfile => file, :filename => File.basename(file)))
      file.close
      @imagetwo.save
    end

    it "creates a new position with a picture" do
      controller.params[:images] = [@image]
      controller.params[:position] = FactoryGirl.attributes_for(:position)
      post :create, controller.params
      expect(Position.count).to eq(1)
      expect(Picture.count).to eq(1)
      expect(Position.first.pictures.count).to eq(1)
    end

    it "creates a new position with multiple pictures" do
      controller.params[:images] = [@image, @imagetwo]
      controller.params[:position] = FactoryGirl.attributes_for(:position)
      post :create, controller.params
      expect(Position.count).to eq(1)
      expect(Picture.count).to eq(2)
      expect(Position.first.pictures.count).to eq(2)
    end

  end
end
