Rails.application.routes.draw do

  mount RestfulSync::Engine => "/restful_sync"
end
