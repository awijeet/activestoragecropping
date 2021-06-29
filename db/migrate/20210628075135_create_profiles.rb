class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :city
      t.boolean :image_rendered, default: false
      t.timestamps
    end
  end
end
