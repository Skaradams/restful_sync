module Glysellin
  class PaymentMethodObserver < ApiObserver
    register self, Glysellin::PaymentMethod
  end
end