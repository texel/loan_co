class CreateDisclosureForms < ActiveRecord::Migration
  def self.up
    create_table :disclosure_forms do |t|
      t.string :first_name
      t.string :last_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :email
      
      t.timestamps
    end
  end

  def self.down
    drop_table :disclosure_forms
  end
end
