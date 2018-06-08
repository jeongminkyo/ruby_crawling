class CreateJiras < ActiveRecord::Migration[5.0]
  def change
    create_table :jiras do |t|
      t.string :num
      t.string :title
      t.string :assignee
      t.string :reporter
      t.string :status
      t.string :created

      t.timestamps
    end
  end
end
