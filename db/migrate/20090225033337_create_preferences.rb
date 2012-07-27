class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.integer :user_id, :null => false
      t.integer :site_id, :null => false
      t.string  :keywords, :length => 500
      t.integer :throttle
      t.boolean :twitter_only
      t.boolean :twitter_self
      t.boolean :twitter_all
      t.timestamps
    end
    add_index :preferences, [:user_id, :site_id]
    add_index :preferences, [:site_id, :user_id]
  end

  def self.down
    drop_table :preferences
  end
end
