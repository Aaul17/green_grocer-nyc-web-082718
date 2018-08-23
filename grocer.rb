def consolidate_cart(cart)
  cart.each_with_object({}) do |items, properties|
    items.each do |type, attribute|
      if properties[type]
        attribute[:count] = attribute[:count] + 1
      else
        attribute[:count] = 1
        properties[type] = attribute
      end
    end
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    food = coupon[:item]
    if cart[food] && cart[food][:count] >= coupon[:num]
      if cart["#{food} W/COUPON"]
        cart["#{food} W/COUPON"][:count] += 1
      else
        cart["#{food} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{food} W/COUPON"][:clearance] = cart[food][:clearance]
      end
      cart[food][:count] = cart[food][:count] - coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |items, properties|
    if properties[:clearance] == true
      properties[:price] = (properties[:price] * 0.80).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart_total = consolidate_cart(cart)
  discount_cart = apply_coupons(cart_total, coupons)
  final_cart = apply_clearance(discount_cart)
  total = 0
  final_cart.each do |items, properties|
    total += properties[:price] * properties[:count]
  end
  if total > 100
    total = total * 0.9
  end
  total
end
