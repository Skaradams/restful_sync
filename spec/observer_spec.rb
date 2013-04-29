require "spec_helper"

describe RestfulSync::ApiObserver do
  describe "API calls from observer" do
    before(:each) do
      @api_format = { :format => kind_of(Nestful::Formats::JsonFormat) }
      RestfulSync.observed_resources = [TestUser, TestProduct]
      RestfulSync::ApiObserver.init_observable

      ActiveRecord::Base.observers = [RestfulSync::ApiObserver]
      ActiveRecord::Base.instantiate_observers

      Nestful.stub(:send) { "test" }
      @email = "test@test.com"
      @source = RestfulSync::ApiClient.first
    end

    it "should call api POST" do
      @user = TestUser.new email: @email

      Nestful.should_receive(:send).with(
        :post, 
        "#{ @source.end_point }/test_users", 
        {"id"=>1, "email"=>@email, "products_attributes"=>{}, model: @user.class.to_s, authentication_token: RestfulSync.api_token}, 
        @api_format
      )
      @user.save
    end

    it "should call api PUT" do
      email = "changed@test.com"
      @user = TestUser.create email: @email
      @user.email = email
      Nestful.should_receive(:send).with(
        :put, 
        "#{ @source.end_point }/test_users/#{ @user.id }", 
        {"id"=>1, "email"=>email, "products_attributes"=>{}, model: @user.class.to_s, authentication_token: RestfulSync.api_token}, 
        @api_format
      )
      @user.save
    end

    it "should call api DELETE" do
      @user = TestUser.create email: @email
      Nestful.should_receive(:send).with(
        :delete, 
        "#{ @source.end_point }/test_users/#{ @user.id }", 
        {"id"=>1, "email"=>@email, "products_attributes"=>{}, model: @user.class.to_s, authentication_token: RestfulSync.api_token}, 
        @api_format
      )
      @user.destroy
    end
  end
end