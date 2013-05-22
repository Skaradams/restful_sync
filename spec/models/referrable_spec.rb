require "spec_helper"

describe RestfulSync::Referrable do
  before(:each) do
    Nestful.stub(:send) { "test" }
    @user_attributes = { "email" => "test@test.com" }

    @products_attributes = []
    @products = []
    @properties = []

    names = %w(name1 name2)
    names.each_with_index do |name, i|
      product = TestProduct.new name: name

      @products << product
      @properties << TestProperty.create(name: name)
      
      @products_attributes << { "name" => name }
    end

    @user = TestUser.new @user_attributes
    @role = TestRole.new name: "role1"
  end

  describe "serializing a model" do
    it "should include valid sync_ref_attributes" do
      @user.save
      hash = @user.to_sync 

      hash.should include(@user_attributes)
      hash.should include("sync_ref_attributes")
      hash["sync_ref_attributes"].should include("uuid")
    end

    it "should send a uuid instead of id" do
      @user.role = @role
      # TODO
    end

    it "should send an array of uuid" do 
      @user.save

      product = @products.first
      product.properties = @properties
      product.save

      hash = product.to_sync
      hash.should include(@products_attributes.first.merge("property_uuids" => @properties.map{ |property| property.sync_ref.uuid }))
    end

    it "should send nested attributes with nested sync_ref" do
      @products.first.properties = @properties
      @user.products << @products.first
      @user.save

      properties_uuids = @properties.map { |property| property.sync_ref.uuid }
      hash = @user.to_sync
    
      hash.should include(@user_attributes)
      hash.should include("products_attributes")
      hash["products_attributes"].first.should include(@products_attributes.first)
      hash["products_attributes"].first.should include("property_uuids" => properties_uuids)
    end
  end

  describe "unserializing a model" do
    it "should find a user from uuid" do
      @user.save

      object = TestUser.from_sync @user.to_sync
      object["id"].should eq(@user.id)
    end

    it "should create a user" do
      count = TestUser.count
      object = TestUser.from_sync @user.to_sync
      user = TestUser.create object

      TestUser.count.should > count
      user.sync_ref.should_not be_nil
      user.sync_ref.uuid.should_not be_blank
    end

    it "should create nested products" do
      @user.products = @products
      object = TestUser.from_sync @user.to_sync
      user = TestUser.create object

      user.products.length.should eq(@products.length)
    end

    it "should find objects from uuid list" do
      @properties.each(&:save)
      @products.first.properties = @properties
      object = TestProduct.from_sync @products.first.to_sync
      product = TestProduct.create object

      product.properties.length.should eq(@properties.length)
    end
  end
end