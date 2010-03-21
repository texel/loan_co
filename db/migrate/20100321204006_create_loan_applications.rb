class CreateLoanApplications < ActiveRecord::Migration
  def self.up
    create_table :loan_applications do |t|
      t.string :full_name
      t.string :email
      t.string :phone
      t.string :amount
      t.string :pdf_name
      
      t.timestamps
    end
  end

  def self.down
    drop_table :loan_applications
  end
end
