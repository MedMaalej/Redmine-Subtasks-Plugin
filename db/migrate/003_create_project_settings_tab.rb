class CreateProjectSettingsTab < ActiveRecord::Migration
  def change
    create_table :project_settings_tabs do |t|
      t.integer :projectId, :default => 0
      t.integer :userId, :default => 0
      t.integer :subtasksTabIsEnabled, :default => 0
    end
  end

   def down
    drop_table :project_settings_tabs
  end
end


