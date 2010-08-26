require 'yaml'
require 'bundler'
Bundler.setup

module BuildInfo
  class Build
   
    def self.build(release_info={})
      f = File.new('.build_info', 'w')
      f.write(YAML::dump(release_info))
      f.close
      @build_info = nil
    end
    
    def self.load
      begin
        f = File.new('.build_info', 'r')
        @build_info = YAML::load(f.read)
      rescue 
        
      end
    end
    
    def self.build_info_str
      str = ''
      str += "\nBuild Information\n\n"
      
      items.each do |i|
        print (i[1].nil ? "NOT AVAILABLE" : i[1])
        print "\n"
      end
      print "\n"
    end
    
    def self.print_build_info_color
      print_color(:green, "\nBuild Information\n\n")

      items.each do |i|
        print_color(:yellow, "#{i[0]}: ")
        print (i[1].nil? ? "NOT AVAILABLE" : i[1])
        print "\n"
      end
      print "\n"
    end
    
    def self.info
      if @build_info.nil?
        load
        return {} if @build_info.nil?
      end
      @build_info
    end
    
    private 
    
    def self.items
      items = [["Name", info['name']], ["Type", info['type']],
      ["Version", info['version']], ["Revision", info['revision']],
      ["Build Number", info['build']]]
    end
    
    def self.print_color(color, txt)
      colorCode = case color
        when :blue then "\033[94m"
        when :green then "\033[92m"
        when :red then "\033[91m"
        when :yellow then "\033[93m"
        else "\033[0m]"
      end
      
      print "#{colorCode}#{txt}\033[0m"
    end
  end
end