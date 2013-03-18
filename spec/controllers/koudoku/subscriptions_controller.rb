require 'spec_helper'

describe Koudoku::SubscriptionsController do
  describe 'when customer is signed in' do
    before do
      @customer = Customer.create(email: 'andrew.culver@gmail.com')
      ApplicationController.any_instance.stub(:current_customer).and_return(@customer)
    end
    it 'works' do
      get :index, use_route: 'koudoku'
    end
  end
  describe 'when customer is not signed in' do
    before do
      ApplicationController.any_instance.stub(:current_customer).and_return(nil)
    end
    it 'works' do
      get :index, use_route: 'koudoku'
    end
  end
end
