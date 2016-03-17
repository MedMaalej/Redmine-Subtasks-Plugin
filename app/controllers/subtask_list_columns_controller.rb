require_dependency 'constants.rb' 

class SubtaskListColumnsController < ApplicationController
  unloadable
  helper_method :index
  helper_method :restoreDefaults
  helper_method :enablePluginTab  
  # before_filter :index 
 # before_filter :require_admin 
   
  def restoreDefaults()
    if (params['restoreRequest'].eql? '1')
       proj  = params['selectedProj'].blank? ? '' : params['selectedProj']
       puts "Project="+ proj
       #puts "OK
       SubtasksConfigList.where(userId: User.current.id).where(projectId: Project.find_by(name: proj)).destroy_all
     
          redirect_to :back
    end
  end
    def enablePluginTab
    
     #puts "CAN DISABLE = #{@canEnableDisable}"
     if params['enablePluginTab'].eql? '1'
          c = ProjectSettingsTab.find_by(userId: User.current.id)
          if c == nil
             c = ProjectSettingsTab.new
          end
          #projId = temp['id']
          c.projectId = 0
          c.userId = User.current.id
          c.subtasksTabIsEnabled = 1
          c.save
          @tabIsEnabled = true
     else 
          
          ProjectSettingsTab.where(userId: User.current.id).destroy_all              
          @tabIsEnabled = false
    
     end

  end
  def index   
     restoreDefaults()  
    if (params['inProject'].eql? '1')
       @inProj = true     
       proj  = params['selectedProj'].blank? ? '' : params['selectedProj']
       @canRestore = User.current.allowed_to?(:restore_default_configuration, Project.find_by(name: proj))
       #puts @canRestore
       @canEnableDisable = User.current.allowed_to?(:enable_and_disable_plugin_tab,Project.find_by(name: proj))
       
       @projects ||= Project.where(name: proj).pluck("name")
       #puts @canEnableDisable
       selectedProject = Project.find_by(name: proj)
       puts selectedProject['id']
       defConfigs ||= SubtasksConfigList.where(userId: User.current.id).where(projectId: selectedProject['id']).pluck("userConfig")
       @defaultConfig = defConfigs.join("").split("|")

    else
       @inProj = false
       @projects ||= Project.pluck("name") 
    end
     c = ProjectSettingsTab.find_by(userId: User.current.id)
     if c == nil
         @tabIsEnabled = false
     else
         @tabIsEnabled = true
     end

    enablePluginTab()       
   
    @currentUser = User.current.id    
    sql = "SELECT  name FROM custom_fields WHERE type = 'IssueCustomField'"
    customFields ||= ActiveRecord::Base.connection.select_all(sql)
    # @selectedColumns = .all 
    @allColumns = Constants::DEFAULT_FIELDS + customFields 
    sql = "SELECT userConfig from subtasks_config_list"
    defConfigs ||= SubtasksConfigList.where(userId: User.current.id).where(projectId: 0).pluck("userConfig")
    @config = defConfigs.join("").split("|")
    #  configs ||= SubtasksConfigList.where(userId: User.current.id).where(projectId: 0).pluck("userConfig")
   # @allConfigs = configs.join("").split("|")

   # sql = "SELECT userConfig  FROM subtasks_config_list where projectId=1" 
   # @allColumns ||= ActiveRecord::Base.connection.select_all(sql) 
    
    
    save = params['save'].blank? ? '' : params['save']
    
  
    
    #show_selected_project_config(proj)    
    if (save.eql? '1')
       config  = params['selectedColumns'].blank? ? '' : params['selectedColumns'] 
       proj  = params['selectedProj'].blank? ? '' : params['selectedProj']
     # if(json != '')
      #  updateSelectedColumns = JSON.parse(json)     
       #SubtasksConfigList.delete_all
       user = User.current.id 
       if (proj == "Global configuration")
          c  = SubtasksConfigList.find_by(id: 1)
          c.projectId = 0
          c.userId = 0
          c.userConfig = config
          c.save
          redirect_to :back
       else
          c = SubtasksConfigList.find_by(userId: User.current.id, projectId: Project.find_by(name: proj))
          if c == nil 
             c = SubtasksConfigList.new
          end
          temp  =  Project.find_by(name: proj)
          #projId = temp['id']
          c.projectId = temp['id'] 
          c.userId = User.current.id
          c.userConfig = config
          c.save
     
          #TODO: do lazy save
          redirect_to :back
      end
    end                                      
  end 
end
