GlysellinParentApi::Engine.routes.draw do
  namespace :orders do 
    post ':attributes', action: :create
    put ':attributes', action: :update
    delete ':attributes', action: :destroy
  end

  namespace :users do 
    post ':attributes', action: :create
    put ':attributes', action: :update
    delete ':attributes', action: :destroy
  end
end
