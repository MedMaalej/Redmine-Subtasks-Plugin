require_dependency 'constants.rb' 

class SubtaskListColumnsController < ApplicationController
  unloadable
  
  def index   
    
    sql = "SELECT id, name FROM projects"
    @projects ||= ActiveRecord::Base.connection.select_all(sql)
    
    sql = "SELECT  name FROM custom_fields WHERE type = 'IssueCustomField'"
    customFields ||= ActiveRecord::Base.connection.select_all(sql)
    
    

    # @selectedColumns = .all 
    @allColumns = Constants::DEFAULT_FIELDS + customFields
    sql = "SELECT userConfig from subtasks_config_list"
 #   @allConfigs ||= SubtaskListColumns.all
   # sql = "SELECT userConfig  FROM subtasks_config_list where projectId=1" 
   # @allColumns ||= ActiveRecord::Base.connection.select_all(sql) 
    
    save = params['save'].blank? ? '' : params['save']

    if (save.eql? '1')
        config  = params['selectedColumns'].blank? ? '' : params['selectedColumns']      
     # if(json != '')
      #  updateSelectedColumns = JSON.parse(json)     
       #SubtasksConfigList.delete_all
       c  = SubtasksConfigList.find_by(id: 1)  
       c.projectId = 0
       c.userId = 0
       c.userConfig = config
       c.save
          #TODO: do lazy save
      end
    end                                      
  end 
