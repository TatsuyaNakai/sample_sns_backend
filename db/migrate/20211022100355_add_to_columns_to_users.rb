class AddToColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :greet, :string, limit: 200, default:""
  end
end
