include RestfulSync::UrlHelper
RestfulSync::Engine.routes.draw do
  custom_resources = RestfulSync.override_api_controller

  RestfulSync.accessible_resources.each do |model|
    path = url_namespace_for(model).split('/').reverse

    res = path.shift
    if custom_resources.include?(model)
      resource_route = proc { resources res, only: [:create, :update, :destroy] }
    else
      resource_route = proc { resources res, only: [:create, :update, :destroy], controller: "api" }
    end
    
    if path.length > 0 
      path.reduce(resource_route) { |block, name| proc { scope name, &block } }.call
    else
      resource_route.call
    end
  end
end

