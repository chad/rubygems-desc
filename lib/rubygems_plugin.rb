require 'rubygems/command'

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

    dep = Gem::Dependency.new name, options[:version]
    specs = Gem.source_index.search dep

    if specs.empty? then
      #try remote
      fetcher = Gem::SpecFetcher.fetcher
      specs = (fetcher.fetch dep, false, false, false)
      specs = specs.first
      if specs.nil? || specs.empty?
        alert_error "No gem found: #{dep}"
        terminate_interaction 1
      end
      specs = [specs.first]
    end

    spec = specs.last
    say "#{spec.name}"
    say "\t#{spec.description}"
  end

end

Gem::CommandManager.instance.register_command :desc
