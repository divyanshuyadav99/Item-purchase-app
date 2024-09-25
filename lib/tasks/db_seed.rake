namespace :db do
    desc "Seed data for SoukoZaiko and PrefectureCode"
    task seed_data: :environment do
      # Prefecture data
      prefecture_data = [
        {name: "茨城県", code: "01", ew_flag: "E"},
        {name: "北海道", code: "02", ew_flag: "E"},
        {name: "青森県", code: "03", ew_flag: "W"}
      ]
  
      prefecture_data.each do |pref|
        PrefectureCode.create!(pref)
      end
  
      # Souko Zaiko data
      souko_zaiko_data = [
        {warehouse_code: "EAST", sku_code: "SKU0001", stock_type: "01", stock: 10},
        {warehouse_code: "WEST", sku_code: "SKU0001", stock_type: "01", stock: 15},
        {warehouse_code: "EAST", sku_code: "SKU0002", stock_type: "01", stock: 5}
      ]
  
      souko_zaiko_data.each do |stock|
        SoukoZaiko.create!(stock)
      end
    end
  end
  