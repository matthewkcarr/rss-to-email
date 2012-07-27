class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :site_id, :null => :no
      t.string :title
      t.timestamps
    end
    add_index :posts, :site_id
  end

  def self.down
    drop_table :posts
  end
end
