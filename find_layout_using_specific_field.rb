require 'filemaker'
require 'yaml'

class FindLayoutUsingSpecificField
  CONFIG_FILE = YAML.load_file('config.yml')

  def fm_server
    fm_server = Filemaker::Server.new do |config|
      config.host         = CONFIG_FILE['fm_server']['host']
      config.account_name = CONFIG_FILE['fm_server']['username']
      config.password     = CONFIG_FILE['fm_server']['password']
    end
  end

  def initialize
    @db_name            = ARGV[0]
    @target_field_name  = ARGV[1]
    @layout_names       = fm_server.database[@db_name].layouts.all # Array
  end

  def layout_name_using_specific_field
    @layout_names.each do |layout_name|
      begin
        fm_server.database[@db_name].layout[layout_name].view.fields.keys.each do |field_name|
          puts "#{layout_name}" if field_name == @target_field_name
        end
      rescue => exception
        puts exception # `Unknown response status = 502 (Layout is missing)`...
      end
    end
  end
end

find_layout = FindLayoutUsingSpecificField.new
find_layout.layout_name_using_specific_field
