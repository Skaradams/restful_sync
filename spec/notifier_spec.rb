require "spec_helper"

describe RestfulSync::ApiNotifier do
  describe "API calls from observer" do
    before(:each) do
      RestfulSync::ApiNotifier.stub(:send) { "test" }
      
      @source = RestfulSync::ApiTarget.first
      @user = TestUser.create email: "test@test.com"
    end

    context "endpoint" do
      it "should build url from endpoint" do
        RestfulSync::ApiNotifier.new().endpoint_for(@source, @user).should eq("/test_users")
      end

      it "should build url from endpoint and id" do
        RestfulSync::ApiNotifier.new().endpoint_for(@source, @user, @user.id).should eq("/test_users/#{@user.id}")
      end
    end
    
    it "should create namespace from object" do 
      RestfulSync::UrlHelper.url_namespace_for(@user.class).should eq("test_users")
    end
  end
end