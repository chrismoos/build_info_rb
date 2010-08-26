require 'rake'

namespace :build_info do
  BUILD_INFO_VARS = {
    :name => "BUILD_INFO_NAME",
    :version => "BUILD_INFO_VERSION",
    :revision => "BUILD_INFO_REVISION",
    :build => "BUILD_INFO_NUMBER",
    :type => "BUILD_INFO_TYPE"
  }
  
  def create_build(type)
    unless ENV.include?("BUILD_INFO_VERSION") and ENV.include?("BUILD_INFO_NAME")
      vars = BUILD_INFO_VARS.collect { |k,v| "#{v}= "}.join(" ")
      raise "usage: rake build_info:init #{vars}"
    end
    
    options = {}
    BUILD_INFO_VARS.each do |k,v|
      options[k.to_s] = ENV[v] if ENV[v]
    end
    
    BuildInfo::Build.build(options)
  end
  
  def update_build_info(build_info, name, var)
    build_info[name.to_s] = var == '' ? nil : var if not var.nil?
  end
  
  def get_build_info
    current_build = BuildInfo::Build.info
    unless current_build.length > 0
      raise "There is no build_info in this project. Please run rake build_info:init."
    end
    current_build
  end
  
  # Tasks
  
  desc "Initializes a new build."
  task :init do
    if File.exists?('.build_info')
      raise "The file .build_info already exists. Please remove it before running this command."
    end
    
    create_build("development")
    
    puts "Created a new build in: #{File.expand_path('.build_info')}"
  end

  desc "Releases the current version."
  task :release do
    current_build = BuildInfo::Build.info
    unless current_build.length > 0
      raise "Unable to release version because there is no build information."
    end

    BuildInfo::Build.build(current_build.merge({
      'type' => 'release'
    }))
  end
  
  desc "Updates the build's version."
  task :version do
    unless ENV.include?("BUILD_INFO_VERSION")
      raise "Please specify the BUILD_INFO_VERSION variable (i.e - 1.0.2)"
    end
    
    current_build = get_build_info

    build_version = current_build['version']
    unless not build_version.nil?
      raise "No build version set, unable to increment."
    end

    BuildInfo::Build.build(current_build.merge({
      'version' => ENV['BUILD_INFO_VERSION']
    }))
    
    puts "Updated version."
    BuildInfo::Build.print_build_info_color
  end
  
  desc "Updates the build information."
  task :update do
    current_build = get_build_info
    
    BUILD_INFO_VARS.each do |k,v|
      update_build_info(current_build, k, ENV[v])
      puts k
      puts v
    end

    BuildInfo::Build.build(current_build)
    puts "Updated build."
    BuildInfo::Build.print_build_info_color
  end
  
  desc "Shows information about the current build."
  task :show do
    BuildInfo::Build.print_build_info_color
  end
end