Rails.application.routes.draw do
  scope ':lang', constraints: Iqvoc.routing_constraint do
    resources :concepts, :controller => "oerk_concepts" do
      member do
        get 'glance'
      end
    end
    resources :collections, :controller => "oerk_collections"
  end
end
