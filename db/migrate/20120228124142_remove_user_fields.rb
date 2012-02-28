class RemoveUserFields < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.remove :email
      t.remove :encrypted_password

      t.remove :reset_password_token
      t.remove :reset_password_sent_at

      t.string :authentication_token
    end

  end

end
