class SpreePrintQuoteHooks < Spree::ThemeSupport::HookListener
  insert_after :admin_order_show_buttons do
    %( <%= button_link_to("Print Quote", {:controller=>"admin/orders", :action=>"quote", :format=>:pdf}) %>)
  end

  insert_after :admin_order_edit_buttons do
    %( <%= button_link_to("Print Quote", {:controller=>"admin/orders", :action=>"quote", :format=>:pdf}) %>)
  end
end