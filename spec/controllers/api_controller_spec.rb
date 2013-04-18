require "spec_helper"

describe RestfulSync::ApiController do
  before(:each) do
    Nestful.stub(:send) { "test" }
    @user = TestUser.create email: "test@test.com"
  end

  describe "POST #create" do
    it "posts with no params and returns 500" do
      post :create, use_route: :restful_sync, model: @user.class.to_s, api: {}

    end
  end
end