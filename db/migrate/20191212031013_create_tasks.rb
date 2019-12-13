class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string      :title, null: false
      t.text        :content, null: false
      t.integer     :status, default: 0

      t.references  :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
