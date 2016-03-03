class CreateSubtasksConfigList < ActiveRecord::Migration
  def change
    create_table :subtasks_config_list do |t|
      t.integer :projectId, :default => 0
      t.integer :userId, :default => 0
      t.text :userConfig, :default => "Subject"
    end
  end

   def down
    drop_table :subtasks_config_list
  end
end


