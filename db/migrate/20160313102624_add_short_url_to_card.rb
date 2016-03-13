class AddShortUrlToCard < ActiveRecord::Migration
  def change
    add_column :cards, :short_url, :text
  end
end
