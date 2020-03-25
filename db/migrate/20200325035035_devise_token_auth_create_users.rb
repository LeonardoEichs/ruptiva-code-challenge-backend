class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[5.2]
  def change
    
    create_table(:users) do |t|
      ## Required
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""

      ## Database authenticatable
      t.string :encrypted_password, :null => false, :default => ""

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip
    

      ## Rememberable
      t.datetime :remember_created_at

      ## User Info
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :deleted, default: false, null: false
      t.integer :role, default: 0, null: false

      ## Tokens
      t.json :tokens

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, [:uid, :provider],     unique: true
  end
end
