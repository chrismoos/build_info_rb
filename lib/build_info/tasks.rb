require 'rake'

namespace :build_info do
  def create_build(type)
    unless ENV.include?("BUILD_INFO_VERSION") and ENV.include?("BUILD_INFO_NAME")
      raise "usage: rake build_info:release BULID_INFO_VERSION=0.1 BUILD_INFO_NAME=myapp BUILD_INFO_REVISION=5556 BUILD_INFO_NUMBER"
    end
    BuildInfo::Build.build({
      'type' => type,
      'version' => ENV['BUILD_INFO_VERSION'],
      'name' => ENV['BUILD_INFO_NAME'],
      'revision' => ENV['BUILD_INFO_REVISION'],
      'build' => ENV['BUILD_INFO_NUMBER']})
  end
  
  
  desc "Creates a release build."
  task :release do
    create_build("release")
  end
  
  desc "Creates a development build."
  task :development do
    create_build("development")
  end
  
  desc "Shows information about the current build."
  task :show do
    BuildInfo::Build.print_build_info
  end
end