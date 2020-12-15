#!/usr/bin/env ruby
require 'find'
require 'FileUtils'

$generic_project_name = 'FirebaseAppBoilerplate'
project_name = 'MyApp'
file_paths = []

def return_first_matching_directory
  Dir.glob("**/*/").each { |path|
    return path.delete_suffix('/') if path =~ /#{Regexp.escape($generic_project_name)}/
  }
  return nil
end
def return_first_matching_file
  Dir.glob("**/*").each { |path|
    return path.delete_suffix('/') if path =~ /#{Regexp.escape($generic_project_name)}/
  }
  return nil
end

Find.find('.') do |path|
  if path =~ /(\.git\/|Pods\/|#{Regexp.escape(File.basename(__FILE__))}$)/
  else
    file_paths << path unless File.directory?(path)
	end
end

replacements = [
	[$generic_project_name, project_name]
]

file_paths.each { |file|
	lines = File.readlines(file).join('')
  replacements.each { |replacement| lines.gsub!(replacement[0], replacement[1]) }
  File.open(file, "w") { |file| file.puts lines }
}

while dir = return_first_matching_directory do
  FileUtils.mv dir, dir.gsub($generic_project_name, project_name)
end
while file = return_first_matching_file do
  FileUtils.mv file, file.gsub($generic_project_name, project_name)
end

puts
puts 'If you are using pods, run pod install again before launching the workspace.'
puts
