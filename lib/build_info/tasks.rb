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
    
    BuildInfo::Build.print_build_info_color
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
  
  def get_version(build_info)
    regex = Regexp.new(/(\d+)\.(\d+)(\.(\d+))?/)
    match = regex.match(build_info['version'])
    
    raise "No or invalid version in build information" if match.nil?
    
    {:major => match[1], :minor => match[2], :patch => match[4]}
  end
  
  def version_string(version_info)
    return version_info[:major] if not version_info[:minor]
    return "#{version_info[:major]}.#{version_info[:minor]}" if not version_info[:patch]
    return "#{version_info[:major]}.#{version_info[:minor]}.#{version_info[:patch]}"
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
  
  namespace :version do
  
    namespace :bump do
      desc "Bumps the build's major version."
      task :major do
        current_build = get_build_info
        version_info = get_version(current_build)
        
        raise "No major version in build information." if version_info[:major].nil?
        
        version_info[:major] = version_info[:major].to_i + 1
        version_info[:minor] = 0
        version_info[:patch] = 0 if not version_info[:patch].nil?

        BuildInfo::Build.build(current_build.merge({'version' => version_string(version_info)}))
        puts "Bumped version."
        BuildInfo::Build.print_build_info_color
      end
      
      desc "Bumps the build's minor version."
      task :minor do
        current_build = get_build_info
        version_info = get_version(current_build)
        
        raise "No minor version in build information." if version_info[:minor].nil?
        
        version_info[:minor] = version_info[:minor].to_i + 1
        version_info[:patch] = 0 if not version_info[:patch].nil?

        BuildInfo::Build.build(current_build.merge({'version' => version_string(version_info)}))
        puts "Bumped version."
        BuildInfo::Build.print_build_info_color
      end
      
      desc "Bumps the build's major version."
      task :patch do
        current_build = get_build_info
        version_info = get_version(current_build)

        if not version_info[:patch].nil?
          version_info[:patch] = version_info[:patch].to_i + 1
        else
          version_info[:patch] = 1
        end
        

        BuildInfo::Build.build(current_build.merge({'version' => version_string(version_info)}))
        puts "Bumped version."
        BuildInfo::Build.print_build_info_color
      end
    end
    
    desc "Set the build version"
    task :update do
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