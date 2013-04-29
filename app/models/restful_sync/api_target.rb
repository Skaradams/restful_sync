module RestfulSync
  class ApiTarget < ActiveRecord::Base
    attr_accessible :end_point
  end
end
