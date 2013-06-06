# Restful sync

You can use Restful sync to synchronize two databases that share the same structure. Each application defines its Restful API and observers that call the other API.

## Dependencies

* [HHTParty](https://github.com/jnunemaker/httparty)

## Configuration

1. Add this line to your Gemfile
```ruby
gem 'restful_sync', git: "git://github.com/vala/restful_sync.git"
```

2. Generate config file :
```bash
rails generate restful_sync:config
```

You will be able to define the namespace for the routes of the API (default: /api)


## Define the application configs

in <tt>config/initializers/restful_sync.rb</tt>
```ruby
RestfulSync.config do |config|
  # Define the observed resources models
  config.observed_resources = [Product, User]

  # Define the accessible resources models
  config.accessible_resources = [Order]

  # Define the targeted API authentication token
  config.api_token = "testapitoken" 
end
```

<tt>observed_resources</tt> is a list of models that trigger a call to the distant API when created, updated or deleted

<tt>accessible_resources</tt> is a list of models that can be accessed through the API

<tt>api_token</tt> is the app token to ensure access to distant API (must have this token registered in its DB)

> A model must not be define in both accessible and observed resources.

## Override API controllers

in <tt>config/initializers/restful_sync.rb</tt>
```ruby
RestfulSync.config do |config|
  # Define models with specific behavior
  config.override_api_controller = []
end
```

<tt>override_api_controller</tt> is a list of custom API controllers

### Example for model <tt>User</tt>
  
routes will be the following :
* POST /users => restful_sync/users#create
* PUT /users/:id => restful_sync/users#update
* DELETE /users/:id => restful_sync/users#destroy

Then you need write your actions in <tt>app/controllers/restful_sync/users_controller.rb</tt>

```ruby
module RestfulSync
  class UsersController < RestfulSync::ApiController
    def create
      user = User.new
      user.encrypted_password = params[:restful_sync].delete(:encrypted_password)
      user.save(validate: false)

      user.update_attributes(params[:restful_sync])
      if user.save
        @status = 200
      else
        @response = user.errors 
      end

      render_json
    end
  end
end
```
