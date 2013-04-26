require "spec_helper"

describe RestfulSync::ApiNotifier do
  describe "API calls from observer" do
    before(:each) do
      Nestful.stub(:send) { "test" }
      
      @source = RestfulSync::ApiSource.first
      @user = TestUser.create email: "test@test.com"
    end

    context "endpoint" do
      it "should build url from endpoint" do
        RestfulSync::ApiNotifier.endpoint_for(@source, @user).should eq("#{@source.end_point}/test_users")
      end

      it "should build url from endpoint and id" do
        RestfulSync::ApiNotifier.endpoint_for(@source, @user, @user.id).should eq("#{@source.end_point}/test_users/#{@user.id}")
      end
    end
    
    it "should create namespace from object" do 
      RestfulSync::UrlHelper.url_namespace_for(@user.class).should eq("test_users")
    end

    it "should return decorated object" do
      RestfulSync::ApiNotifier.decorated(@user).as_json.should eq(RestfulSync::BaseDecorator.decorate(@user).as_json)
    end
  end
end