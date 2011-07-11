Rails.application.routes.draw do
  match "admin/orders/quote/:id" => "admin/orders#quote"
end
