Spree::Admin::OrdersController.class_eval do
  respond_to :pdf

  def quote
    load_order
    respond_with(@order) do |format|
      format.pdf do
        render :layout => false , :template => "spree/admin/orders/quote.pdf.prawn"
      end
    end
  end
end