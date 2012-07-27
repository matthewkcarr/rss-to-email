class SitesUsers < ActiveRecord::Migration
  def self.up
    create_table 'sites_users', :force => true do |t|
      t.column :user_id, :integer, :null => :no
      t.column :site_id, :integer, :null => :no
    end
    add_index :sites_users, [:user_id, :site_id]
    add_index :sites_users, [:site_id, :user_id]
  end

  def self.down
    remove_index :sites_users, :column => :site_id
    remove_index :sites_users, :column => :user_id
    drop_table 'sites_users'
  end
end
