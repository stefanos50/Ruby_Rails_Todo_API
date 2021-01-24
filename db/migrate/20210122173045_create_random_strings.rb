class CreateRandomStrings < ActiveRecord::Migration[6.1]
  def change
    create_table :random_strings do |t|
      t.integer :user_id
      t.string :random_str
      t.string :user_token

      t.timestamps
    end
  end
end
