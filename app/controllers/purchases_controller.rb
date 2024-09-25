class PurchasesController < ApplicationController

  def fetch_all_order_items
    @order_items = OrderItem.all
  end
  
  def new
    @purchase = Order.new
    @souko_zaikos = SoukoZaiko.where(stock_type: '01').where.not(stock: 0) # Available stock
  end

  def create
    unique_number = generate_unique_order_number
    order = Order.create!(order_number: unique_number, total_amount: params[:order][:order_items][:total_amount].to_i, delivery_zipcode: params[:order][:delivery_zipcode], delivery_state: params[:order][:delivery_state], delivery_city: params[:order][:delivery_city])
    order_item = OrderItem.create!(order_id: order.id, sku_code: params[:order][:order_items][:sku_code], quantity: params[:order][:order_items][:quantity].to_i, price: params[:order][:order_items][:price].to_i, total_amount: params[:order][:order_items][:total_amount].to_i)
    @purchase = order
    if order.save && order_item.save
      # Deduct stock based on E/W flag
      deduct_stock(order.order_items)
      redirect_to fetch_all_order_items_purchases_path , notice: 'Order was successfully created.'
    else
      redirect_to new_purchase_path, alert: @purchase.errors.full_messages.to_sentence
    end
  end

  private

  def order_params
    params.require(:order).permit(:delivery_zipcode, :delivery_state, :delivery_city, :total_amount, order_items_attributes: [:sku_code, :quantity, :price, :total_amount])
  end

  def deduct_stock(order_items)
    order_items.each do |item|
      souko_zaiko = SoukoZaiko.find_by(sku_code: item.sku_code)
      if souko_zaiko
        ew_flag = get_ew_flag_based_on_prefecture('北海道') # Implement this method
        if souko_zaiko.stock > item.quantity
          souko_zaiko.update(stock: souko_zaiko.stock - item.quantity)
          # Create a new entry in SoukoZaiko with stock_type '02'
          SoukoZaiko.create(sku_code: item.sku_code, stock: item.quantity, stock_type: '02')
        else
          handle_out_of_stock(item)
        end
      else
        handle_sku_not_found(item)
      end
    end
  end

  def get_ew_flag_based_on_prefecture(state)
    # Define a mapping of prefectures to their East/West flags
    ew_flags = {
      '北海道' => 'E',
      '青森県' => 'W',
      '岩手県' => 'E',
      '宮城県' => 'E',
      '秋田県' => 'E',
      '山形県' => 'E',
      '福島県' => 'E',
      '茨城県' => 'E',
      '栃木県' => 'E',
      '群馬県' => 'E',
      '埼玉県' => 'E',
      '千葉県' => 'E',
      '東京都' => 'E',
      '神奈川県' => 'E',
      '新潟県' => 'W',
      '富山県' => 'W',
      '石川県' => 'W',
      '福井県' => 'W',
      '山梨県' => 'E',
      '長野県' => 'W',
      '岐阜県' => 'W',
      '静岡県' => 'W',
      '愛知県' => 'W',
      '三重県' => 'W',
      '滋賀県' => 'W',
      '京都府' => 'W',
      '大阪府' => 'W',
      '兵庫県' => 'W',
      '奈良県' => 'W',
      '和歌山県' => 'W',
      '鳥取県' => 'W',
      '島根県' => 'W',
      '岡山県' => 'W',
      '広島県' => 'W',
      '山口県' => 'W',
      '徳島県' => 'W',
      '香川県' => 'W',
      '愛媛県' => 'W',
      '高知県' => 'W',
      '福岡県' => 'W',
      '佐賀県' => 'W',
      '長崎県' => 'W',
      '熊本県' => 'W',
      '大分県' => 'W',
      '宮崎県' => 'W',
      '鹿児島県' => 'W',
      '沖縄県' => 'W'
    }
  
    # Return the EW flag based on the prefecture name, defaulting to 'Unknown'
    ew_flags[state] || 'Unknown'
  end  
  
  def handle_out_of_stock(item)
    # Here, you can define what to do when an item is out of stock
    # For example, you can log the event, notify the user, or mark the order item as backordered.
    
    Rails.logger.warn("Out of stock for SKU: #{item.sku_code}, requested quantity: #{item.quantity}")
    
    # Example notification (you may need to adjust based on your notification system)
    item.errors.add(:base, "SKU #{item.sku_code} is out of stock. Requested quantity: #{item.quantity}. Please reduce the quantity or choose another item.")
  end
  
  def handle_sku_not_found(item)
    # Handle case where the SKU is not found in the SoukoZaiko table
    Rails.logger.warn("SKU not found: #{item.sku_code}")
    item.errors.add(:base, "SKU #{item.sku_code} not found. Please check the SKU code.")
  end

  def generate_unique_order_number
    loop do
      # Generate the current date in YYYYMMDD format
      date_part = Time.now.strftime("%Y%m%d")
      
      # Generate a random 5-digit number
      random_part = rand(10000..99999).to_s
      
      # Combine both parts to form the order number
      order_number = "#{date_part}#{random_part}"
      
      # Check if the order number is unique
      break order_number unless Order.exists?(order_number: order_number)
    end
  end
end
