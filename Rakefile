require 'rubygems' unless ENV['NO_RUBYGEMS']
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'
require 'spec/rake/spectask'
require 'bundler'

GEM = "build_info"
GEM_VERSION = "0.1"

spec = Gem::Specification.new do |s|
  s.name = "#{GEM}"
  s.version = "#{GEM_VERSION}"
  s.author = "Chris Moos"
  s.email = "chris@tech9computers.com"
  s.homepage = "http://chrismoos.com.com"
  s.description = 'Manages build information for projects.'
  
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "LICENSE", 'TODO']
  s.summary = ''
  
  s.add_bundler_dependencies

  s.require_path = 'lib'
  s.files = %w(Gemfile LICENSE README.rdoc Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
end

task :default => :spec

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
end


Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end