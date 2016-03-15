require 'redmine'
require_dependency 'subtask_list_columns_lib'
require_dependency 'subtask_list_columns_project_helper_patch'

Rails.configuration.to_prepare do
  unless IssuesHelper.included_modules.include?(SubtaskListColumnsLib)
      IssuesHelper.send(:include, SubtaskListColumnsLib)
  end
end


Redmine::Plugin.register :subtask_list_columns do
  name 'Subtask list columns plugin'
  author 'Squeezer software'
  description 'Customize columns to show in subtasks (issues)  details page '
  version '0.0.1'
  project_module :subtasks_list_columns do
     permission :create_or_save_configuration, :subtaskListColumns => :index
     permission :enable_and_disable_plugin_tab, :subtaskListColumns => :enablePluginTab
     permission :restore_default_configuration, :subtaskListColumns => :restoreDefaults
     menu :admin_menu, :subtask_list_columns, {:controller => 'subtask_list_columns', :action => 'index'}, :caption => :subtask_list_columns
     permission :manage_project_workflow, {}, :require => :member
  end


 # permission :create_save_config, :subtaskListColumns => :index
 # permission :restore_config, :subtaskListColumns => :restoreDefaults
 # menu :admin_menu, :subtask_list_columns, {:controller => 'subtask_list_columns', :action => 'index'}, :caption => :subtask_list_columns
 # permission :manage_project_workflow, {}, :require => :member
end
