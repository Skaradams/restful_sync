require "spec_helper"

describe RestfulSync::BaseDecorator do
  describe "API calls from observer" do
    before(:each) do
      Nestful.stub(:send) { "test" }

      @user_attributes = { "email" => "test@test.com" }

      @products_attributes = {}
      @products = []
      @properties = []

      names = %w(name1 name2)
      names.each_with_index do |name, i|
        product = TestProduct.new name: name
        product.save
        @products << product
        @products_attributes[i.to_s] = { "name" => name, "id" => product.id, "property_ids" => [] }

        @properties << TestProperty.create(name: name)
      end
      
      @user = TestUser.create @user_attributes
    end

    it "should build hash of attributes" do
      hash = @user_attributes.merge("id" => @user.id, "products_attributes" => {})
      
      RestfulSync::ApiNotifier.decorated(@user).as_json.should eq(hash)
    end

    it "should build recursive hash of attributes" do
      @user.products = @products
      @user.save
      hash = @user_attributes.merge("id" => @user.id, "products_attributes" => @products_attributes)

      RestfulSync::ApiNotifier.decorated(@user).as_json.should eq(hash)
    end

    it "should build hash with array of ids" do
      product = @products.first
      product.test_user_id = @user.id
      product.property_ids = @properties.map{ |property| property.id.to_s }
      hash = @products_attributes["0"].merge("property_ids" => @properties.map{ |property| property.id.to_s })
      
      RestfulSync::ApiNotifier.decorated(product).as_json.should eq(hash)
    end

    # TODO : test Has one
  end
end