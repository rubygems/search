require 'spec_helper'

describe SearchController do
  
  render_views
  
  describe "#search" do
    it "should respond successfully without a query" do
      get :search
      response.should be_success
    end
    
    it "should respond successfully with a query" do
      get :search, :q => 'test'
      response.should be_success
    end
  end
  
end