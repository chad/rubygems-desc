require 'rubygems/command'

class Gem::Commands::DescCommand < Gem::Command

  include Gem::VersionOption

  def initialize
    super 'desc', 'Get description of a gem given its name',
          :version => Gem::Requirement.default

    add_version_option
  end

  def arguments # :nodoc:
    'GEMNAME       name of an installed gem to describe'
  end

  def usage # :nodoc:
    "#{program_name} GEMNAME [options]"
  end

  def execute
    name = get_one_gem_name

    dep = Gem::Dependency.new name, options[:version]
    specs = Gem.source_index.search dep

    if specs.empty? then
      alert_error "No installed gem #{dep}"
      terminate_interaction 1
    end

    spec = specs.last
    say "#{spec.name}"
    say "\t#{spec.description}"
  end

end

Gem::CommandManager.instance.register_command :desc
