require 'rubygems/command'
require 'httparty'

class RemoteGem
  attr_accessor :name, :version, :authors, :info, :downloads, :rubyforge_project
  include HTTParty
  format :json
  def self.info_for(name)
    data = get("http://gemcutter.org/api/v1/gems/#{name}.json")
    data.code == 404 ? nil : new(data)
  end
  
  def initialize(hash)
    hash.each do |key, value|
      __send__("#{key}=", value)
    end
  end
end


class Gem::Commands::DescCommand < Gem::Command


  def initialize
    super 'desc', 'Get description of a gem given its name',
          :version => Gem::Requirement.default
  end

  def arguments # :nodoc:
    'GEMNAME       name of a gem to describe'
  end

  def usage # :nodoc:
    "#{program_name} GEMNAME [options]"
  end

  def execute
    name = get_one_gem_name
    remote_gem = RemoteGem.info_for(name)
    if remote_gem
      say "version: #{remote_gem.version}"
      say "authors: #{remote_gem.authors}"
      say "downloads: #{remote_gem.downloads}"
      say ""
      say "\t#{remote_gem.info}"
    else
      say "Couldn't find #{name} in repository"
    end
  end

end

Gem::CommandManager.instance.register_command :desc
