# Address Stuff
spec = Gem::Specification.find_by_name("spree_print_invoice")
gem_root = spec.gem_dir
fonts_path = gem_root + "/lib/data/fonts/"

font_families.update("Angsa" => {
  :normal => "#{fonts_path} + Angsa.ttf",
  :bold => "#{fonts_path} + /Angsab.ttf"
})

font_families.update("AngsaUPC" => {
  :normal => "#{fonts_path} + AngsaUPC.ttf",
  :bold => "#{fonts_path} + /AngsabUPC.ttf"
})

bill_address = @order.bill_address
ship_address = @order.ship_address
anonymous = @order.email =~ /@example.net$/


bounding_box [0,600], :width => 540 do
  move_down 2
  data = [[Prawn::Table::Cell.new( :text => I18n.t(:billing_address), :font_style => :bold ),
                Prawn::Table::Cell.new( :text =>I18n.t(:shipping_address), :font_style => :bold )]]

  table data,
    :position           => :center,
    :border_width => 0.5,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 9,
    :border_style => :underline_header,
    :column_widths => { 0 => 270, 1 => 270 }

  move_down 2
  horizontal_rule

  bounding_box [0,0], :width => 540 do
    move_down 2
    if anonymous and Spree::Config[:suppress_anonymous_address]
      data2 = [[" "," "]] * 6
    else
      data2 = [["#{bill_address.firstname} #{bill_address.lastname}", "#{ship_address.firstname} #{ship_address.lastname}"],
            [bill_address.address1, ship_address.address1]]
      data2 << [bill_address.address2, ship_address.address2] unless
                bill_address.address2.blank? and ship_address.address2.blank?
      data2 << ["#{@order.bill_address.city}  #{(@order.bill_address.state_name ? @order.bill_address.state_name : "")} #{@order.bill_address.zipcode}",
                  "#{@order.ship_address.zipcode} #{@order.ship_address.city} #{(@order.ship_address.state_name ? @order.ship_address.state_name : "")}"]
      data2 << [bill_address.country.name, ship_address.country.name]
      data2 << [bill_address.phone, ship_address.phone]
      data2 << [@order.shipping_method.try(:name), @order.shipping_method.try(:name)]
    end

    font "Angsa"

    table data2,
      :font_size => 9,
      :column_widths => {0 => 270, 1 => 270},
      :border_width => 0,
      :height => 20

  end

  move_down 2

  font "Helvetica"
  stroke do
    line_width 0.5
    line bounds.top_left, bounds.top_right
    line bounds.top_left, bounds.bottom_left
    line bounds.top_right, bounds.bottom_right
    line bounds.bottom_left, bounds.bottom_right
  end

end
