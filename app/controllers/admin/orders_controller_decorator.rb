Admin::OrdersController.class_eval do
  respond_to :pdf
  
  def quote
    @order = Order.find_by_number( params[:id] )
    respond_with( @order )
  end
end