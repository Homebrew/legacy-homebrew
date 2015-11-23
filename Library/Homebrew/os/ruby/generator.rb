# Script to generate the skeleton for a rvmRubyMetrics publisher
require 'rubygems'
require 'erubis'
require 'fileutils'

# grabbed from active_support
def camelize(string, first_up = true)
  if first_up
    string.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
  else
    string[0].chr.downcase + camelize(string)[1..-1]
  end
end

def template(name)
  Erubis::Eruby.new(File.read(File.join(File.dirname(__FILE__), 'templates', name)))
end

def ask_empty(message)
  begin 
    print message
    answer = gets.chomp
  end while answer.empty?
  answer
end

def ask_bool(message)
  begin
    print message
    answer = gets.chomp
    answer = 'N' if answer.empty?
  end while !(answer =~ /[NnSs]/)
  answer.downcase == 's'
end

def write(path, content)
  File.open(path, "w") do |file|
    file.write(content)
  end
end

real_name = ask_empty('the name of the tool to add support for is: ')

tool_name = real_name.gsub(/\s+/, '_')
camelized_name = camelize(tool_name)
package_name = camelize(tool_name, false)

puts "generating directory structure..."

java_base_directory = File.join(File.dirname(__FILE__), '..', 'java', 'hudson', 'plugins', 'rvmRubyMetrics', package_name)
java_model_directory = File.join(java_base_directory, 'model')
FileUtils.mkdir_p java_base_directory
FileUtils.mkdir_p java_model_directory

jelly_directory = File.join(File.dirname(__FILE__), '..', 'resources', 'hudson', 'plugins', 'rvmRubyMetrics', package_name)
jelly_paths = {}
["#{camelized_name}Publisher", "#{camelized_name}BuildAction", "#{camelized_name}ProjectAction"].each do |path|
  jelly_paths[path] = FileUtils.mkdir_p File.join(jelly_directory, path)
end

options = {
  :real_name => real_name,
  :tool_name => tool_name,
  :camelized_name => camelized_name,
  :package_name => package_name
}
publisher_template = 'publisher.eruby'

rails_task = ask_bool('are you going to parse the output of a rails task? (N/s) ')
if (rails_task)
  options[:rake_task] = ask_empty("the rake task that I'm going to run is: ")
  publisher_template = 'rails_task_publisher.eruby'
else
  options[:html_report] = ask_bool('are you going to publish an html parsed? (N/s) ')

  options[:superclass_name] = options[:html_report] ? 'HtmlPublisher' : 'AbstractRubyMetricsPublisher'

  options[:health_report] = ask_bool('are you going to use health thresholds? (N/s) ')
end

puts "generating skeleton for #{camelized_name}Publisher..."
publisher = template(publisher_template).evaluate(options)
write("#{java_base_directory}/#{camelized_name}Publisher.java", publisher)

puts "generating skeleton for #{camelized_name}BuildAction..."
build_action = template('build_action.eruby').evaluate(options)
write("#{java_base_directory}/#{camelized_name}BuildAction.java", build_action)

puts "generating skeleton for #{camelized_name}ProjectAction..."
project_action = template('project_action.eruby').evaluate(options)
write("#{java_base_directory}/#{camelized_name}ProjectAction.java", project_action)

puts "generating skeleton for #{camelized_name}BuildResults..."
build_results = template('build_results.eruby').evaluate(options)
write("#{java_model_directory}/#{camelized_name}BuildResults.java", build_results)

puts "generating publisher configuration view..."
options[:config_title] = ask_empty('the title of the configuration option is: ')
print 'the description of the configuration option is: '
options[:config_description] = gets.chomp
publisher_view = template('jelly/publisher_config.eruby').evaluate(options)
write(File.join(jelly_paths["#{camelized_name}Publisher"], 'config.jelly'), publisher_view)

puts "generating build action view..."
build_view = template('jelly/build_action.eruby').evaluate(options)
write(File.join(jelly_paths["#{camelized_name}BuildAction"], 'index.jelly'), build_view)

puts "generating project action view..."
project_box_view = template('jelly/project_action_box.eruby').evaluate(options)
write(File.join(jelly_paths["#{camelized_name}ProjectAction"], 'floatingBox.jelly'), project_box_view)

FileUtils.cp File.join(File.dirname(__FILE__), 'templates', 'jelly/project_action_no_data.eruby'),
  File.join(jelly_paths["#{camelized_name}ProjectAction"], 'nodata.jelly')

puts "end."
