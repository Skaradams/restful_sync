unless defined? SpecProduct
  require 'active_record'

  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

  ActiveRecord::Migration.create_table :test_products do |t|
    t.string :name
    t.integer :test_user_id  
  end

  ActiveRecord::Migration.create_table :test_users do |t|
    t.string :email
    t.integer :test_role_id
  end

  ActiveRecord::Migration.create_table :test_properties do |t|
    t.string :name
    t.integer :test_product_id
  end

  ActiveRecord::Migration.create_table :test_roles do |t|
    t.string :name
  end

  ActiveRecord::Migration.create_table :restful_sync_api_clients do |t|
    t.string :authentication_token
  end  

  ActiveRecord::Migration.create_table :restful_sync_api_targets do |t|
    t.string :end_point
  end

  ActiveRecord::Migration.create_table :restful_sync_sync_refs do |t|
    t.integer :resource_id
    t.string :resource_type
    t.string :uuid
  end


  class TestProperty < ActiveRecord::Base
    belongs_to :product, class_name: 'TestProduct'
    
    attr_accessible :name
  end

  class TestRole < ActiveRecord::Base
    has_one :user, class_name: 'TestUser'
    
    attr_accessible :name
  end

  class TestUser < ActiveRecord::Base
    has_many :products, class_name: 'TestProduct', dependent: :destroy
    belongs_to :role, class_name: 'TestRole', dependent: :destroy
    attr_accessible :email, :products_attributes

    accepts_nested_attributes_for :products, allow_destroy: true
    validates_presence_of :email
  end

  class TestProduct < ActiveRecord::Base
    belongs_to :user, class_name: 'TestUser'
    has_many :properties, class_name: 'TestProperty'
    attr_accessible :name, :property_ids, :properties
  end

  token = "test_token"
  RestfulSync::ApiClient.create authentication_token: token
  RestfulSync::ApiTarget.create end_point: "test.com"
  RestfulSync.api_token = token
end

