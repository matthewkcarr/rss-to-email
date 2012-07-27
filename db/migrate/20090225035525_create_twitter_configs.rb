class CreateTwitterConfigs < ActiveRecord::Migration
  def self.up
    create_table :twitter_configs do |t|
      t.integer :user_id
      t.string :twitter_username
      t.string :twitter_password
      t.timestamps
    end
    add_index :twitter_configs, :user_id
  end

  def self.down
    drop_table :twitter_configs
  end
end
