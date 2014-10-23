require 'prawn/layout'

bill_address = @order.bill_address ? @order.bill_address : Address.new

ship_address = @order.ship_address ? @order.ship_address : Address.new

pdf.font "Helvetica"

im = Rails.application.assets.find_asset( SpreePrintSettings::Config[:print_logo_path] )

pdf.image im, :at => [0,720], :scale => 0.65

pdf.fill_color "005D99"
pdf.text "Customer Quote", :align => :center, :style => :bold, :size => 22
pdf.fill_color "000000"

pdf.text SpreePrintSettings::Config[:print_company_name], :style => :bold, :align => :right, :size=>16
pdf.text SpreePrintSettings::Config[:print_company_address1], :align => :right, :size=>14
pdf.text SpreePrintSettings::Config[:print_company_address2], :align => :right, :size=>14
pdf.text SpreePrintSettings::Config[:print_company_phone], :align => :right, :size=>14

pdf.font "Helvetica", :style => :bold, :size => 14
pdf.text "Order Number: #{@order.number}"

pdf.font "Helvetica", :size => 8
if @order.created_at.blank? == false
   pdf.text @order.created_at.to_s(:long)
end

# Address Stuff
pdf.bounding_box [0,600], :width => 540 do
  pdf.move_down 2
  data = [[Prawn::Table::Cell.new( :text => "Billing Address", :font_style => :bold ),
                Prawn::Table::Cell.new( :text =>"Shipping Address", :font_style => :bold )]]

  pdf.table data,
    :position           => :center,
    :border_width => 0.5,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 9,
    :border_style => :underline_header,
    :column_widths => { 0 => 270, 1 => 270 }

  pdf.move_down 2
  pdf.horizontal_rule

  pdf.bounding_box [0,0], :width => 540 do
    pdf.move_down 2
    data2 = [[ "#{bill_address.firstname} #{bill_address.lastname}", "#{ship_address.firstname} #{ship_address.lastname}" ],
            [ bill_address.address1, ship_address.address1 ]]
    data2 << [bill_address.address2, ship_address.address2] unless bill_address.address2.blank? and ship_address and ship_address.address2.blank?
    data2 << ["#{bill_address.city}, #{(bill_address.state ? bill_address.state.abbr : "")} #{bill_address.zipcode}",
              "#{ship_address.city}, #{(ship_address.state ? ship_address.state.abbr : "")} #{ship_address.zipcode}"]
    data2 << [bill_address.country ? bill_address.country.name : "", ship_address.country ? ship_address.country.name : ""]
    data2 << [bill_address.phone, ship_address.phone]

    pdf.table data2,
      :position           => :center,
      :border_width => 0.0,
      :vertical_padding   => 0,
      :horizontal_padding => 6,
      :font_size => 9,
      :column_widths => { 0 => 270, 1 => 270 }
  end

  pdf.move_down 2

  pdf.stroke do
    pdf.line_width 0.5
    pdf.line pdf.bounds.top_left, pdf.bounds.top_right
    pdf.line pdf.bounds.top_left, pdf.bounds.bottom_left
    pdf.line pdf.bounds.top_right, pdf.bounds.bottom_right
    pdf.line pdf.bounds.bottom_left, pdf.bounds.bottom_right
  end

end

pdf.move_down 30

# Line Items
pdf.bounding_box [0, pdf.cursor], :width => 540, :height => 440 do
  pdf.move_down 2
  data =  [[Prawn::Table::Cell.new( :text => "SKU", :font_style => :bold),
                Prawn::Table::Cell.new( :text =>"Item Description", :font_style => :bold ),
               Prawn::Table::Cell.new( :text =>"Price", :font_style => :bold ),
               Prawn::Table::Cell.new( :text =>"Qty", :font_style => :bold, :align => 1 ),
               Prawn::Table::Cell.new( :text =>"Total", :font_style => :bold )]]

  pdf.table data,
    :position           => :center,
    :border_width => 0,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 9,
    :column_widths => { 0 => 100, 1 => 265, 2 => 75, 3 => 50, 4 => 50 } ,
    :align => { 0 => :left, 1 => :left, 2 => :right, 3 => :right, 4 => :right }

  pdf.move_down 4
  pdf.horizontal_rule
  pdf.move_down 2

  pdf.bounding_box [0, pdf.cursor], :width => 540 do
    pdf.move_down 2
    data2 = []
    @order.line_items.each do |item|
      data2 << [item.variant.respond_to?('sku') ? item.variant.sku : item.variant.product.sku,
                item.variant.product.name,
                number_to_currency(item.price),
                item.quantity,
                number_to_currency(item.price * item.quantity)]
    end
	
    pdf.table data2,
      :position           => :center,
      :border_width => 0,
      :vertical_padding   => 5,
      :horizontal_padding => 6,
      :font_size => 9,
      :column_widths => { 0 => 100, 1 => 265, 2 => 75, 3 => 50, 4 => 50 },
      :align => { 0 => :left, 1 => :left, 2 => :right, 3 => :right, 4 => :right }
  end

  pdf.font "Helvetica", :size => 9

  totals = []

  totals << [Prawn::Table::Cell.new( :text => "Subtotal:", :font_style => :bold), @order.display_item_total]

  totals << [Prawn::Table::Cell.new( :text => "Shipping:", :font_style => :bold), @order.display_shipment_total]

  totals << [Prawn::Table::Cell.new( :text => "Taxes:", :font_style => :bold), @order.display_additional_tax_total]

  totals << [Prawn::Table::Cell.new( :text => "Order Total:", :font_style => :bold), @order.display_total]

  pdf.bounding_box [ pdf.bounds.right - 500, pdf.bounds.bottom + (totals.length * 15)], :width => 500 do
    pdf.table totals,
      :position => :right,
      :border_width => 0,
      :vertical_padding   => 2,
      :horizontal_padding => 6,
      :font_size => 9,
      :column_widths => { 0 => 425, 1 => 75 } ,
      :align => { 0 => :right, 1 => :right }

  end

  pdf.move_down 2

  pdf.stroke do
    pdf.line_width 0.5
    pdf.line pdf.bounds.top_left, pdf.bounds.top_right
    pdf.line pdf.bounds.top_left, pdf.bounds.bottom_left
    pdf.line pdf.bounds.top_right, pdf.bounds.bottom_right
    pdf.line pdf.bounds.bottom_left, pdf.bounds.bottom_right
  end

end

# Footer
pdf.repeat :all do
  footer_message = <<EOS
Shipping is not refundable. | Special orders are non-refundable.
In order to return a product prior authorization with a RMA number is mandatory
All returned items must be in original un-opened packaging with seal intact.
EOS
  pdf.move_down 2
  pdf.text SpreePrintSettings::Config[:print_company_website], :align => :right, :size=>10
  pdf.text_box footer_message, :at => [ pdf.margin_box.left, pdf.margin_box.bottom + 40], :size => 8
end
