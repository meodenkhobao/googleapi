class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :mail
      t.string :photo
      t.string :google_id
      t.string :google_profile_url
      t.string :access_token

      t.timestamps
    end
  end
end
