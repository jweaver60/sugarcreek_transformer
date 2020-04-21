class OrderTransformService
  require 'csv'

  def initialize(file)
    @file = file
  end

  def transform
    headers = [
      "PO Number (Header)", 
      "Item", 
      "Total Item Quantity", 
      "Recipient Full Name",
      "Recipient First Name",
      "Recipient Last Name",
      "Address Line 1",
      "Address Line 2",
      "Address Line 3",
      "City",
      "State",
      "Postal Code",
      "Country Code"
    ]

    csv_data = CSV.generate(headers: true) do |csv|
      csv << headers

      CSV.foreach(@file.path, headers: true, liberal_parsing: true) do |order|
        full_name = ""
        first_name = ""
        last_name = ""
        address_1 = ""
        address_2 = ""
        address_3 = ""
        city = ""
        state = ""
        postal_code = ""
        country_code = ""

        address = order[3].split("\n")
        name = order[4].split(" ")

        full_name = name[0...-1].join(" ")
        first_name = full_name.split(" ").first
        last_name = full_name.split(" ").drop(1).join(" ")

        if address.count == 3
          address_1 = address[0]
          city = address[1].split(" ")[0...-2].join(" ").gsub(",", "")
          state = address[1].split(" ")[-2]
          postal_code = address[1].split(" ").last
          country_code = address[2]
        end

        if address.count == 4
          address_1 = address[0]
          address_2 = address[1]
          city = address[2].split(" ")[0...-2].join(" ").gsub(",", "")
          state = address[2].split(" ")[-2]
          postal_code = address[2].split(" ").last
          country_code = address[3]
        end

        if address.count == 5
          address_1 = address[0]
          address_2 = address[1]
          address_3 = address[2]
          city = address[3].split(" ")[0...-2].join(" ").gsub(",", "")
          state = address[3].split(" ")[-2]
          postal_code = address[3].split(" ").last
          country_code = address[4]
        end

        csv << [order[0], order[1], order[2], full_name, first_name, last_name, address_1, address_2, address_3, city, state, postal_code, country_code]
      end
    end

    csv_data
  end
end