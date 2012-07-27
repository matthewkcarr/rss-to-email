class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :name, :length => 500
      t.timestamps
    end
    add_index :sites, :name, :unique => true
  end

  def self.down
    drop_table :sites
  end
end
