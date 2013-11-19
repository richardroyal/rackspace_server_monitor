require "spec_helper"

describe BooleanSettingsController do
  describe "routing" do

    it "routes to #index" do
      get("/boolean_settings").should route_to("boolean_settings#index")
    end

    it "routes to #new" do
      get("/boolean_settings/new").should route_to("boolean_settings#new")
    end

    it "routes to #show" do
      get("/boolean_settings/1").should route_to("boolean_settings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/boolean_settings/1/edit").should route_to("boolean_settings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/boolean_settings").should route_to("boolean_settings#create")
    end

    it "routes to #update" do
      put("/boolean_settings/1").should route_to("boolean_settings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/boolean_settings/1").should route_to("boolean_settings#destroy", :id => "1")
    end

  end
end
