require 'csv'
module CsvHelper

  # generates a CSV file based on an array of
  #   Item objects (for legit CSV rows)
  # or
  #   Arrays of strings (for bogus rows)
  def generate_csv_file(items)
    tmp_file_name = "#{Rails.root}/tmp/batch_#{Time.now.to_i}.csv"
    attributes = %i{id size color status style_type style_name style_id created_at updated_at price_sold}

    CSV.open(tmp_file_name, "wb") do |csv|
      items.each do |item|
        if item.kind_of?(Item)
          csv << attributes.map { |attr| item.send(attr) }
        else
          # assumes an array of strings
          csv << item
        end
      end
    end

    tmp_file_name
  end

end
