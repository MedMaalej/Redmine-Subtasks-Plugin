class CreateSubtasksConfigList < ActiveRecord::Migration
  def change
    create_table :subtasks_config_list do |t|
      t.integer :projectId
      t.integer :userId
      t.text :userConfig
    end
  end

   def down
    drop_table :subtasks_config_list
  end
end


