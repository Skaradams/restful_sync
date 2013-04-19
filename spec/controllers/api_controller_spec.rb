require "spec_helper"

describe RestfulSync::ApiController do
  before(:each) do
    Nestful.stub(:send) { "test" }

    @user_attributes = { "email" => "test@test.com" }

    
    @products = []
    @properties = []
    @user = TestUser.new @user_attributes
    names = %w(name1 name2)
    names.each_with_index do |name, i|
      product = TestProduct.new name: name

      property = TestProperty.create(name: name)

      product.properties << property

      @products << product
      @properties << property
    end
  end

  describe "POST #create" do
    context "simple model" do
      it "posts with no params and returns 404" do
        post :create, use_route: :restful_sync, model: @user.class.to_s, api: {}
      
        response.code.should eq("404")
      end

      it "posts with valid params and returns 200" do
        count = TestUser.count

        post :create, use_route: :restful_sync, model: @user.class.to_s, api: RestfulSync::ApiNotifier.decorated(@user).as_json
      
        response.code.should eq("200")
        TestUser.count.should > count
      end
    end

    context "embedded models" do
      it "posts with valid params and returns 200" do
        count = TestUser.count        
        @user.products = @products

        post :create, use_route: :restful_sync, model: @user.class.to_s, api: RestfulSync::ApiNotifier.decorated(@user).as_json

        response.code.should eq("200")
        TestUser.count.should > count
      end
    end
  end

  describe "PUT #update" do

  end
end