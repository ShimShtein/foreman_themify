Rails.application.routes.draw do

  match 'new_action', :to => 'foreman_themify/hosts#new_action'

end
