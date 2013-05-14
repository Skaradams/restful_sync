# require "spec_helper"

# describe RestfulSync::NestedResourceHelper do
#   describe "Creates objects from attributes hash" do
#     include RestfulSync::NestedResourceHelper 

#     before(:each) do
#       Nestful.stub(:send) { "test" }

#       @model = TestUser
#       @user_attributes = { "email" => "test@test.com" }

#       @products_attributes = {}
#       @products = []
#       @properties = []

#       names = %w(name1 name2)
#       names.each_with_index do |name, i|
#         product = TestProduct.new name: name
#         @products << product


#         @properties << TestProperty.create(name: name)
#         @products_attributes[i.to_s] = { "name" => name, "id" => product.id, "property_ids" => [] }
#       end
      
#       @user = TestUser.new @user_attributes
#       @role = TestRole.new name: "role1"
#     end

#     it "creates no user" do
#       @params = { "api" => {} }
#       self.stub!(:params).and_return( @params )

#       process_nested_resource
#       TestUser.count.should eq(0)
#     end

#     it "creates a simple user" do
#       @params = { "api" => @user_attributes }

#       count = TestUser.count

#       self.stub!(:params).and_return( @params )
#       process_nested_resource

#       @model.count.should > count
#     end

#     it "creates a user with nested models" do
#       @products = @products.map do |product|
#         product.properties = @properties
#         product
#       end

#       @user.products = @products
      
#       @user.save

#       @params = { "api" => RestfulSync::ApiNotifier.decorated(@user).as_json }
#       @user.destroy

#       count = TestUser.count

#       self.stub!(:params).and_return( @params )
#       process_nested_resource

#       user = @model.last
#       @model.count.should > count
#       TestProduct.count.should > 0
      
#       user.products.first.properties.length.should > 0
#       user.products.first.properties.should eq(@properties)
#     end

#   end
# end