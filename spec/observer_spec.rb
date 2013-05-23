require "spec_helper"

describe RestfulSync::ApiObserver do
  describe "API calls from observer" do
    before(:each) do
      RestfulSync.observed_resources = [TestUser, TestProduct]
      RestfulSync::ApiObserver.init_observable

      ActiveRecord::Base.observers = [RestfulSync::ApiObserver]
      ActiveRecord::Base.instantiate_observers

      RestfulSync::ApiNotifier.stub(:send) { "test" }
      @email = "test@test.com"
      @source = RestfulSync::ApiTarget.first
    end

    it "should call api POST", wip: true do
      @user = TestUser.new email: @email
      @user.id = 1
      @user.sync_ref = RestfulSync::SyncRef.new uuid: "testuuid"
      
      RestfulSync::ApiNotifier.should_receive(:send).with(
        :post, 
        "/test_users", 
        base_uri: @source.end_point,
        body: {restful_sync: @user.to_sync.merge(model: @user.class.to_s, authentication_token: RestfulSync.api_token)}
      )

      @user.save

    end

    it "should call api PUT" do
      email = "changed@test.com"
      @user = TestUser.create email: @email
      @user.email = email
      RestfulSync::ApiNotifier.should_receive(:send).with(
        :put, 
        "/test_users/#{ @user.sync_ref.uuid }", 
        base_uri: @source.end_point,
        body: {restful_sync: @user.to_sync.merge(model: @user.class.to_s, authentication_token: RestfulSync.api_token)}
      )
      @user.save
    end

    it "should call api DELETE" do
      @user = TestUser.create email: @email
      RestfulSync::ApiNotifier.should_receive(:send).with(
        :delete, 
        "/test_users/#{ @user.sync_ref.uuid }", 
        base_uri: @source.end_point,
        body: {restful_sync: @user.to_sync.merge(model: @user.class.to_s, authentication_token: RestfulSync.api_token)}
      )
      @user.destroy
    end
  end
end