# Restful sync

You can use Restful sync to synchronize two databases that share the same structure. Each application defines its Restful API and observers that call the other API.

## Dependencies

* [Nestful](https://github.com/maccman/nestful)
* [Draper](https://github.com/drapergem/draper)

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

  # Define the targeted API URL
  config.end_point = "www.example.com/api"

  # Define models with specific behavior
  config.override_api_controller = []
end
```

<tt>observed_resources</tt> is a list of models that trigger a call to the distant API when created, updated or deleted

<tt>accessible_resources</tt> is a list of models that can be accessed through the API

<tt>end_point</tt> is the base URL to the distant API


## Override API controllers

in <tt>config/initializers/restful_sync.rb</tt>
```ruby
RestfulSync.config do |config|
  # Define models with specific behavior
  config.override_api_controller = []
end
```

<tt>override_api_controller</tt> is a list of models that will have specific routes

Example for model <tt>User</tt>

routes will be the following :
* POST /users => restful_sync/users#create
* PUT /users/:id => restful_sync/users#update
* DELETE /users/:id => restful_sync/users#destroy

Then you need write your actions in <tt>app/controllers/restful_sync/users_controller.rb</tt>

```ruby
def create
  user = User.create params[:user]
  
  # @status and @response can be re-defined
  if user.save
    @status = 200
  else
    @response = object.errors 
  end

  # Must be called at the end of the action
  render_json
end
```

If you don't define some actions in your controller, it will fallback to default behavior