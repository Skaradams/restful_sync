module Glysellin
  class ProductObserver < ApiObserver
    register self, Glysellin::Product
  end
end