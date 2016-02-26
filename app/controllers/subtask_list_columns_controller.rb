require_dependency 'constants.rb' 

class SubtaskListColumnsController < ApplicationController
  unloadable
  
  def index   
    
    sql = "SELECT id, name FROM projects"
    @projects ||= ActiveRecord::Base.connection.select_all(sql)
    
    sql = "SELECT  name FROM custom_fields WHERE type = 'IssueCustomField'"
    customFields ||= ActiveRecord::Base.connection.select_all(sql)
    
    @selectedColumns = SubtasksConfigList.all 
    @allColumns = Constants::DEFAULT_FIELDS + customFields
   # sql = "SELECT userConfig  FROM subtasks_config_list where projectId=1" 
   # @allColumns ||= ActiveRecord::Base.connection.select_all(sql) 
    
   # save = params['save'].blank? ? '' : params['save']

    #if (save.eql? '1')
     # json = params['selectedColumns'].blank? ? '' : params['selectedColumns']
      
     # if(json != '')
      #  updateSelectedColumns = JSON.parse(json)     
        
       # SubtasksConfigList.delete_all()
        
#        updateSelectedColumns.each do |col|
 #         c = SubtasksConfigList.new
  #        c.projectId = col["projectId"]
   #       c.userId = col["userId"]
    #      c.userConfig = col["userConfig"]
     #     c.save
          #TODO: do lazy save
#        end   
 #     end
  #  end                                      
  end  
end
