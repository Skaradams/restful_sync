require "spec_helper"

describe RestfulSync::ApiNotifier do
  describe "API calls from observer" do
    before(:each) do
      Nestful.stub(:send) { "test" }
      @endpoint = "test.com"
      RestfulSync.end_point = @endpoint
      @user = TestUser.create email: "test@test.com"
    end

    it "should build url from endpoint" do
      RestfulSync::ApiNotifier.endpoint_for(@user).should eq("#{@endpoint}/test_users")
    end

    it "should build url from endpoint and id" do
      RestfulSync::ApiNotifier.endpoint_for(@user, @user.id).should eq("#{@endpoint}/test_users/#{@user.id}")
    end

    it "should create namespace from object" do 
      RestfulSync::UrlHelper.url_namespace_for(@user.class).should eq("test_users")
    end

    it "should return decorated object" do
      RestfulSync::ApiNotifier.decorated(@user).as_json.should eq(RestfulSync::BaseDecorator.decorate(@user).as_json)
    end
  end
end