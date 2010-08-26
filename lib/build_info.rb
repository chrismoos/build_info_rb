module BuildInfo
  ROOT = File.expand_path(File.dirname(__FILE__))

  autoload :Build,      "#{ROOT}/build_info/build"
end