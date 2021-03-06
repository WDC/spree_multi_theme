Deface::Override.new(:virtual_path => %q{spree/shared/_order_details},
                          :name => %q{replace_shared_order_details},
                          :replace => %q{.steps-data},
                          :closing_selector => %q{table},
                          :text => %q{
<div class="row steps-data">

  <div class="columns alpha four">
    <h5><%= t(:shipping_address) %> <%= link_to "(#{t(:edit)})", checkout_state_path(:address) unless @order.completed? %></h5><br/>
    <div class="address">
      <%= order.ship_address %>
    </div>
  </div><br/>

  <div class="columns alpha four">
    <h5><%= t(:billing_address) %> <%= link_to "(#{t(:edit)})", checkout_state_path(:address) unless @order.completed? %></h5><br/>
    <div class="address">
      <%= order.bill_address %>
    </div>
  </div><br/>

  <div class="columns alpha four">
    <h5><%= t(:shipping_method) %> <%= link_to "(#{t(:edit)})", checkout_state_path(:delivery) unless @order.completed? %></h5><br/>
    <div class="delivery">
      <%= order.shipping_method.name %>
    </div>
  </div><br/>

  <div class="columns omega four">
    <h5><%= t(:payment_information) %> <%= link_to "(#{t(:edit)})", checkout_state_path(:payment) unless @order.completed? %></h5><br/>
    <div class="payment-info">
      <% unless order.creditcards.empty? %>
        <span class="cc-type">
          <%#= image_tag "creditcards/icons/#{order.creditcards.first.cc_type}.png" %>
          <%#= t(:ending_in)%> Card Ending With : &nbsp;<%= order.creditcards.first.last_digits %>
        </span>
        <br /><br />
        <span class="full-name">
          <%= order.creditcards.first.first_name %>
          <%= order.creditcards.first.last_name %>
        </span>
      <% end %>
    </div>
  </div>
</div>

<table class="index columns alpha omega sixteen grid-table" data-hook="order_details">
  <thead id="line-items" data-hook>
    <tr data-hook="order_details_line_items_headers">
      <th class="image"><b><%= t(:image) %></b></th>
      <th class="desc"><%= t(:item) %></th>
      <th class="price" ><%= t(:price) %></th>
      <th class="qty"><%= t(:qty) %></th>
      <th class="total"><span><%= t(:total) %></span></th>
    </tr>
  </thead>

  <tbody id="line-items" data-hook>
    <% @order.line_items.each do |item| %>
      <tr data-hook="order_details_line_item_row">
        <td data-hook="order_item_image">
          <% if item.variant.images.length == 0 %>
            <%= link_to small_image(item.variant.product), item.variant.product %>
          <% else %>
            <%= link_to image_tag(item.variant.images.first.attachment.url(:small)), item.variant.product %>
          <% end %>
        </td>
        <td data-hook="order_item_description">
          <h4><%= item.variant.product.name %></h4>
          <%= truncate(item.variant.product.description, :length => 100, :omission => "...") %>
          <%= "(" + variant_options(item.variant) + ")" unless item.variant .option_values.empty? %>
        </td>
        <td data-hook="order_item_price" class="price"><span><%= number_to_currency item.price %></span></td>
        <td data-hook="order_item_qty"><%= item.quantity %></td>
        <td data-hook="order_item_total" class="total"><span><%= number_to_currency (item.price * item.quantity) %></span></td>
      </tr>
    <% end %>
  </tbody><br/>
  <tfoot id="order-total" data-hook="order_details_total">
    <tr class="total">
      <td colspan="4"><b><%= t(:order_total) %>:</b></td>
      <td class="total"><span id="order_total"><%= number_to_currency @order.total %></span></td>
    </tr>
  </tfoot>
  <% if order.price_adjustment_totals.present? %>
    <tfoot id="price-adjustments" data-hook="order_details_price_adjustments">
      <% @order.price_adjustment_totals.keys.each do |key| %>
        <tr class="total">
          <td colspan="4"><strong><%= key %></strong></td>
          <td class="total"><span><%= number_to_currency @order.price_adjustment_totals[key] %></span></td>
        </tr>
      <% end %>
    </tfoot>
  <% end %>
  <tfoot id="subtotal" data-hook="order_details_subtotal">
    <tr class="total" id="subtotal-row">
      <td colspan="4" class="subtotal"><b><%= t(:subtotal) %>:</b></td>
      <td class="total"><span><%= number_to_currency @order.item_total %></span></td>
    </tr>
  </tfoot>
  <tfoot id="order-charges" data-hook="order_details_adjustments">
    <% @order.adjustments.eligible.each do |adjustment| %>
    <% next if (adjustment.originator_type == 'Spree::TaxRate') and (adjustment.amount == 0) %>
      <tr class="total">
        <td colspan="4" class="subtotal"><strong><%= adjustment.label %></strong></td>
        <td class="total"><span><%= number_to_currency adjustment.amount %></span></td>
      </tr>
    <% end %>
  </tfoot>
</table>})
