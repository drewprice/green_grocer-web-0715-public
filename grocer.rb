require 'pry'

cart = [
  { 'TEMPEH'       => { price: 3.0, clearance: true  } },
  { 'PEANUTBUTTER' => { price: 3.0, clearance: true  } },
  { 'ALMONDS'      => { price: 9.0, clearance: false } },
  { 'AVOCADO'      => { price: 3.0, clearance: true  } },
  { 'AVOCADO'      => { price: 3.0, clearance: true  } }
]

def consolidate_cart(cart:[])
  cart.uniq.each_with_object({}) do |item, new_cart|
    name       = item.keys.first
    attributes = item.values.first

    attributes[:count] = cart.count(item)

    new_cart[name] = attributes
  end
end

coupons = [{:item => "AVOCADO", :num => 2, :cost => 5.0}]

def apply_coupons(cart:[], coupons:[])
  coupons.uniq.each_with_object(cart) do |coupon, new_cart|
    item = coupon[:item]

    next unless cart.include? item

    coupon_count = cart[item][:count] / coupon[:num]
    coupon_count = coupons.count(coupon) if coupon_count > coupons.count(coupon)

    new_cart["#{item} W/COUPON"] = {
      price:     coupon[:cost],
      clearance: cart[item][:clearance],
      count:     coupon_count
    }

    new_cart[item][:count] = cart[item][:count] - (coupon_count * coupon[:num])
  end
end

def apply_clearance(cart:[])
  cart.each_with_object(cart) do |item_arr, new_cart|
    if item_arr.last[:clearance]
      price = new_cart[item_arr.first][:price]
      new_cart[item_arr.first][:price] = (price * 0.8).round(2)
    end
  end
end

def checkout(cart: [], coupons: [])
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)

  total = cart.reduce(0) do |sum, item|
    sum + (item.last[:price] * item.last[:count])
  end

  total > 100 ? total * 0.9 : total
end
