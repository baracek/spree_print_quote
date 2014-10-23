Deface::Override.new(:virtual_path => "spree/admin/shared/_content_header",
                     :name => "quote_button",
                     :insert_top => "[data-hook='toolbar']>ul",
                     :partial => "spree/admin/orders/quote_button",
                     :disabled => false)