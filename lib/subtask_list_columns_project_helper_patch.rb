module CCULProjectsHelperPatch
  def self.included(base)
  base.send(:include, ProjectsHelperMethodsCCUL)

  base.class_eval do
    unloadable
    alias_method_chain :project_settings_tabs, :subtask_list_columns
  end
 end
end

module ProjectsHelperMethodsCCUL
  def project_settings_tabs_with_subtask_list_columns
    @tabs = project_settings_tabs_without_subtask_list_columns
    @action = {:name => 'subtasks_tab', :partial => 'tab/show', :label => :subtasks_tab}
    Rails.logger.info "old_tabs: #{@tabs}"
    Rails.logger.info "action: #{@action}"
    @tabs << @action #if User.current.allowed_to?(action, @project)
    @tabs
 end
end

ProjectsHelper.send(:include, CCULProjectsHelperPatch) unless ProjectsHelper.included_modules.include? CCULProjectsHelperPatch
