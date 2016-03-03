require_dependency 'issues_helper'
require 'date'

module SubtaskListColumnsLib
    
    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            alias_method_chain :render_descendants_tree, :listed
      end
    end

    module InstanceMethods

      def render_descendants_tree_with_listed(issue)
       
        record = SubtasksConfigList.where(userId: 0).where(projectId: 0).pluck(:userConfig)
        toStr = record.join("")
        fields_list = toStr.split("|")        
        field_values = ''
        field_headers = ''

        s = '<form><table class="list issues">'
        
        if(fields_list.count == 0) 
          #if the project column is not set, show: subject, status, assigned_to and done_ratio
         
          s << content_tag('tr',
          content_tag('th', l(:field_subject)) +
          content_tag('th', l(:field_status)) +
          content_tag('th', l(:field_assigned_to)) +   
          field_headers.html_safe +       
          content_tag('th', l(:field_done_ratio)))

          issue_list(issue.descendants.visible.sort_by(&:lft)) do |child, level|

            css = "issue issue-#{child.id} hascontextmenu"
            css << " idnt idnt-#{level}" if level > 0
            field_content = 
               content_tag('td', check_box_tag("ids[]", child.id, false, :id => nil), :class => 'checkbox') +
               content_tag('td', link_to_issue(child, :truncate => 160), :class => 'subject') +
               content_tag('td align="center"', h(child.status)) +
               content_tag('td align="center"', link_to_user(child.assigned_to))

            field_content << content_tag('td', progress_bar(child.done_ratio, :width => '80px'))
            field_values << content_tag('tr', field_content, :class => css).html_safe
          end
       else 
         # show columns from table
          
          # set header - columns names
          fields_list.each do |field|
            if(field  == 'tracker' || field  == 'subject')
              next
             end  
       #   s << content_tag('th style="text-align:left"', l(:field_subject))        
          s << content_tag('th style="text-align:left"',field)               
       end
       # set data
          issue_list(issue.descendants.visible.sort_by(&:lft)) do |child, level|

              css = "issue issue-#{child.id} hascontextmenu"
              css << " idnt idnt-#{level}" if level > 0
              
              field_content = 
               content_tag('td', check_box_tag("ids[]", child.id, false, :id => nil), :class => 'checkbox') 
                #get_first_column_in_table(child, !fields_list.detect{|f| f['ident'] == 'tracker'}.nil?, !fields_list.detect{|f| f['ident'] == 'subject'}.nil?)
             # field_content << content_tag('td', link_to_issue(child, :truncate => 160), :class => 'subject')
              fields_list.each do |field|
                 if(field  == 'tracker' || field  == 'subject')
                  next
                 end              
               # field_content << content_tag('td', link_to_issue(child, :truncate => 160), :class => 'subject') 
                
                
                # first looking for the default
                 
                  case field
                  when 'Tracker'
                    field_content  <<  get_td(child.tracker)
                   when 'Target version'
                    field_content  <<  get_td(child.lock_version)
                  when 'Project'
                    field_content  <<  get_td(link_to_project(child.project))
                  when 'Subject'
                    field_content  <<  get_td(link_to_issue(child, :truncate => 160))
                  when 'Description'
                    field_content << get_td(child.description.truncate(100)) 
                  when 'Due date'
                    field_content << get_td(format_date(child.due_date))
                  when 'Category'
                    field_content << get_td(child.category)
                  when 'Status'
                    field_content << get_td(h(child.status))                    
                  when 'Assignee'
                    field_content << get_td(link_to_user(child.assigned_to))
                  when 'Priority'
                    field_content << get_td(child.priority)
                  when 'Author'
                    field_content << get_td(link_to_user(child.author)) 
                  when 'Created'
                    field_content << get_td(format_time(child.created_on))
                  when 'Updated'
                    field_content << get_td(format_time(child.updated_on))
                  when 'Start date'
                    field_content << get_td(format_date(child.start_date))
                  when '% Done'
                    field_content << get_td(progress_bar(child.done_ratio, :width => '70px'))
                  when 'Estimated time'
                    field_content << get_td(child.total_estimated_hours())  
                   when 'Spent time'
                    field_content << get_td(child.total_spent_hours()) 
                  when 'Parent task'
                    field_content << get_td(link_to_issue(child.parent, :tracker=> false, :subject => false))  
                  when 'Due date'
                    field_content << get_td(format_time(child.closed_on))
                  when 'Private'
                    field_content << get_td(child.is_private ? l(:general_text_yes) : l(:general_text_no))
                  else
                    field_content << get_td("Undefined")                    
                  end
                    
                 
                
 #         puts field_content      
  
          end
          field_values << content_tag('tr', field_content, :class => css).html_safe   
          end
        end   
        s << field_values
        s << '</table></form>'
        s.html_safe
      
      end
     

      private 
      def get_td(value)
        content_tag('td style="text-align:left"', value)
      end
    end
end

