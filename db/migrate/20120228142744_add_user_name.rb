class AddUserName < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.column :name, :string
    end
  end
end
