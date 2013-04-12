include GlysellinParentApi::UrlHelper
GlysellinParentApi::Engine.routes.draw do
  GlysellinParentApi.accessible_resources.each do |model|

    path = url_namespace_for(model).split('/').reverse
    res = path.shift
    resource_route = proc { resources res, only: [:create, :update, :destroy], controller: "api" }
    
    if path.length > 0 
      path.reduce(resource_route) { |block, name| proc { scope name, &block } }.call
    else
      resource_route.call
    end
  end
end

